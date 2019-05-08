---
title: "HttpClient 3.x : a portable SSL Socket Factory implementation"
date: 2012-01-18 22:13:36 +0100
layout: post
permalink: articles/httpclient-3x-portable-ssl-socket-factory-implementation
tags:
  - cryptography
  - https
  - java
  - ssl
  - WebSphere
---

## I*M Hell

I was just trying to implement client and server authentication over SSL on IBM Websphere 6 (JRE 1.4.2)...

Problems started to happen with a :

    java.io.IOException: Error in loading the keystore: Private key decryption error: (java.lang.SecurityException: Unsupported keysize or algorithm parameters)
      at com.ibm.crypto.provider.PKCS12KeyStore.engineLoad(Unknown Source)
      at java.security.KeyStore.load(KeyStore.java:695)
      ... 30 more

... easily solved by replacing the JRE's policy files (`local_policy.jar` and `US_export_policy.jar`) with an unlimited version of them (ah, policy, policy...). *If you are looking for this, I used [Websphere ones](https://www14.software.ibm.com/webapp/iwm/web/reg/pick.do?source=jcesdk) (you will need an IBM.com account)*.

I was far from having a working solution (see [this thread](https://www.ibm.com/developerworks/forums/thread.jspa?messageID=14778991&#14778991)), but apart from the fact that I would have to provide strong reasons for this change to the architecture and production teams, this led me to another challenge : **I would have to implement HTTPS access with client authentication !**


## A SSL socket factory implemented for you

It may sound awkward in 2012, but if you wish the HTTPS server to identify your Java client (versus : only the server is identified), **you will have to write your own implementation of a socket factory**.

The Java Runtime Environment doesn't provide ready-to-use classes to do this. Yes : there is [`javax.net.ssl.SSLSocketFactory.getDefault()`](http://docs.oracle.com/javase/1.4.2/docs/api/javax/net/ssl/SSLSocketFactory.html#getDefault%28%29) but it requires to set some system (therefore global) properties to point to the certificates files !!!

Even with Apache's HttpClient (at least version 3.x), you have to use a custom [SSLProtocolSocketFactory](http://hc.apache.org/httpclient-3.x/apidocs/org/apache/commons/httpclient/protocol/SSLProtocolSocketFactory.html).

The [HttpClient SSL Guide](http://hc.apache.org/httpclient-3.x/sslguide.html) provides sample code to implement mutual client and server authentication ; unfortunately the latest stable release of it (contrib 3.1) is bound to Sun's API with imports such as `com.sun.net.ssl.KeyManagerFactory`. Needless to say that this will not work on an IBM Websphere JRE...

*Note : There was some change in the latest trunk revisions but it looks like they are made for HttpClient 4.x...*

Well, we finally come to the purpose of this article : *a cleaned-up version of a SSLProtocolSocketFactory for HttpClient 3.1 that you can use with any JRE*.

Just get the 2 classes from the next chapter and use as in the following code.
Parameters are self-explanatory : URL, password and type of both the keystore and the truststore (see the Javadoc)...

```java
HttpClient hc = new HttpClient();
SecureProtocolSocketFactory protoSocketFactory = new ClientAndServerSSLSocketFactory(crtClient, crtClientPwd, crtClientType, crtServer, crtServerPwd, crtServerType);
Protocol authhttps = new Protocol("https", protoSocketFactory, port);
hc.getHostConfiguration().setHost(host, port, authhttps);
```

## Debugging

Although IBM now follows the general JSSE rules, you should notice that the previous "IBMJSSE" JSSE implementation (not "IBMJSSE2") uses `javax.net.debug=true` instead of `javax.net.debug=all` to display all traces (it took me some time to figure it out).

See [ibm.com/developerworks/java/jdk/security/142/secguides/jsse2docs/JSSE2RefGuide.html#Debug](http://www.ibm.com/developerworks/java/jdk/security/142/secguides/jsse2docs/JSSE2RefGuide.html#Debug) and [docs.oracle.com/javase/1.5.0/docs/guide/security/jsse/JSSERefGuide.html#Debug](http://docs.oracle.com/javase/1.5.0/docs/guide/security/jsse/JSSERefGuide.html#Debug) for more details.


## Source

Get the classes at github :

- [ClientAndServerAuthSSLSocketFactory](https://gist.github.com/1625857)
- [SSLHelper](https://gist.github.com/1625871)

Or here :

```java
package nicobo.ssl;

import java.io.IOException;
import java.net.InetAddress;
import java.net.Socket;
import java.net.URL;
import java.net.UnknownHostException;
import java.security.KeyStore;
import java.security.cert.Certificate;
import java.security.cert.X509Certificate;
import java.util.Enumeration;

import javax.net.ssl.KeyManager;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;

import org.apache.commons.httpclient.ConnectTimeoutException;
import org.apache.commons.httpclient.params.HttpConnectionParams;
import org.apache.commons.httpclient.protocol.SecureProtocolSocketFactory;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * From "Apache commons HttpClient contrib"
 *
 * @see <a
 *      href="http://hc.apache.org/httpclient-3.x/sslguide.html">http://hc.apache.org/httpclient-3.x/sslguide.html</a>
 * @see <a href="http://svn.apache.org/viewvc/httpcomponents/oac.hc3x/trunk/
 * src/contrib/org/apache/commons/httpclient/contrib/ssl/AuthSSLProtocolSocketFactory.java?
 * view=markup">AuthSSLProtocolSocketFactory.java</a>
 */
public class ClientAndServerAuthSSLSocketFactory implements
		SecureProtocolSocketFactory {

	private static final Log LOG = LogFactory
			.getLog(ClientAndServerAuthSSLSocketFactory.class);

	private URL keystoreUrl = null;

	private String keystorePassword = null;

	private String keystoreType;

	private URL truststoreUrl = null;

	private String truststorePassword = null;

	private String truststoreType;

	private SSLContext sslcontext = null;

	public KeyManager[] keymanagers;

	public TrustManager[] trustmanagers;

	/**
	 * Either a keystore or truststore file must be given. Otherwise SSL context
	 * initialization error will result.
	 *
	 * @param keystoreUrl
	 *            URL of the keystore file. May be <tt>null</tt> if HTTPS client
	 *            authentication is not to be used.
	 * @param keystorePassword
	 *            Password to unlock the keystore. IMPORTANT: this
	 *            implementation assumes that the same password is used to
	 *            protect the key and the keystore itself.
	 * @param keystoreType
	 *            Keystore type (format) (e.g. : "JKS", "PKCS12")
	 * @param truststoreUrl
	 *            URL of the truststore file. May be <tt>null</tt> if HTTPS
	 *            server authentication is not to be used.
	 * @param truststoreType
	 *            Password to unlock the truststore.
	 * @param keyStoreType
	 *            Truststore type (format) (e.g. : "JKS", "PKCS12")
	 */
	public ClientAndServerAuthSSLSocketFactory(final URL keystoreUrl,
			final String keystorePassword, final String keystoreType,
			final URL truststoreUrl, final String truststorePassword,
			final String truststoreType) {
		super();
		this.keystoreUrl = keystoreUrl;
		this.keystorePassword = keystorePassword;
		this.keystoreType = keystoreType;
		this.truststoreUrl = truststoreUrl;
		this.truststorePassword = truststorePassword;
		this.truststoreType = truststoreType;
	}

	private SSLContext getSSLContext() throws IOException,
			UnsupportedOperationException {
		if (this.sslcontext == null) {
			this.sslcontext = createSSLContext();
		}
		return this.sslcontext;
	}

	private SSLContext createSSLContext() throws IOException,
			UnsupportedOperationException {
		try {
			KeyManager[] keymanagers = null;
			TrustManager[] trustmanagers = null;
			if (this.keystoreUrl != null) {
				KeyStore keystore = SSLHelper.createKeyStore(this.keystoreUrl,
						this.keystorePassword, this.keystoreType);
				if (LOG.isDebugEnabled()) {
					Enumeration aliases = keystore.aliases();
					while (aliases.hasMoreElements()) {
						String alias = (String) aliases.nextElement();
						Certificate[] certs = keystore
								.getCertificateChain(alias);
						if (certs != null) {
							LOG.debug("Certificate chain '" + alias + "':");
							for (int c = 0; c < certs.length; c++) {
								if (certs[c] instanceof X509Certificate) {
									X509Certificate cert = (X509Certificate) certs[c];
									LOG.debug(" Certificate " + (c + 1) + ":");
									LOG.debug("  Subject DN: "
											+ cert.getSubjectDN());
									LOG.debug("  Signature Algorithm: "
											+ cert.getSigAlgName());
									LOG.debug("  Valid from: "
											+ cert.getNotBefore());
									LOG.debug("  Valid until: "
											+ cert.getNotAfter());
									LOG.debug("  Issuer: " + cert.getIssuerDN());
								}
							}
						}
					}
				}
				keymanagers = SSLHelper.createKeyManagers(keystore,
						this.keystorePassword);
				this.keymanagers = keymanagers;
			}
			if (this.truststoreUrl != null) {
				KeyStore keystore = SSLHelper.createKeyStore(
						this.truststoreUrl, this.truststorePassword,
						this.truststoreType);
				if (LOG.isDebugEnabled()) {
					Enumeration aliases = keystore.aliases();
					while (aliases.hasMoreElements()) {
						String alias = (String) aliases.nextElement();
						LOG.debug("Trusted certificate '" + alias + "':");
						Certificate trustedcert = keystore
								.getCertificate(alias);
						if (trustedcert != null
								&& trustedcert instanceof X509Certificate) {
							X509Certificate cert = (X509Certificate) trustedcert;
							LOG.debug("  Subject DN: " + cert.getSubjectDN());
							LOG.debug("  Signature Algorithm: "
									+ cert.getSigAlgName());
							LOG.debug("  Valid from: " + cert.getNotBefore());
							LOG.debug("  Valid until: " + cert.getNotAfter());
							LOG.debug("  Issuer: " + cert.getIssuerDN());
						}
					}
				}
				trustmanagers = SSLHelper.createTrustManagers(keystore);
				this.trustmanagers = trustmanagers;
			}
			SSLContext sslcontext = SSLContext.getInstance("TLS");
			sslcontext.init(keymanagers, trustmanagers, null);
			return sslcontext;
		} catch (IOException e) {
			LOG.error("An I/O error occured while reading a keystore", e);
			throw e;
		} catch (Exception e) {
			LOG.error("Could not initialize a SSL context", e);
			throw new UnsupportedOperationException(e);
		}
	}

	/**
	 * @see SecureProtocolSocketFactory#createSocket(java.lang.String,int,java.net.InetAddress,int)
	 */
	public Socket createSocket(String host, int port, InetAddress clientHost,
			int clientPort) throws IOException, UnknownHostException,
			UnsupportedOperationException {
		return getSSLContext().getSocketFactory().createSocket(host, port,
				clientHost, clientPort);
	}

	/**
	 * @see SecureProtocolSocketFactory#createSocket(java.lang.String,int)
	 */
	public Socket createSocket(String host, int port) throws IOException,
			UnknownHostException, UnsupportedOperationException {
		return getSSLContext().getSocketFactory().createSocket(host, port);
	}

	/**
	 * @see SecureProtocolSocketFactory#createSocket(java.net.Socket,java.lang.String,int,boolean)
	 */
	public Socket createSocket(Socket socket, String host, int port,
			boolean autoClose) throws IOException, UnknownHostException,
			UnsupportedOperationException {
		return getSSLContext().getSocketFactory().createSocket(socket, host,
				port, autoClose);
	}

	public Socket createSocket(final String host, final int port,
			final InetAddress localAddress, final int localPort,
			final HttpConnectionParams params) throws IOException,
			UnknownHostException, ConnectTimeoutException,
			UnsupportedOperationException {
		// TODO ? use HttpConnectionParams ?
		return getSSLContext().getSocketFactory().createSocket(host, port,
				localAddress, localPort);
	}

}



package nicobo.ssl;

import java.io.IOException;
import java.net.URL;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;

import javax.net.ssl.KeyManager;
import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.X509TrustManager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * SSL connections utilities
 */
public class SSLHelper {

	private static final Log log = LogFactory.getLog(SSLHelper.class);

	/**
	 * Builds a keystore from a file.
	 *
	 * @param url
	 *            URL to the keystore file
	 * @param password
	 *            Keystore password
	 * @param keystoreType
	 *            Keystore type (cf <a href=
	 *            "http://docs.oracle.com/javase/1.4.2/docs/guide/security/CryptoSpec.html#AppA"
	 *            >Appendix A in the Java Cryptography Architecture API
	 *            Specification & Reference</a>)
	 */
	public static KeyStore createKeyStore(final URL url, final String password,
			final String keystoreType) throws KeyStoreException,
			NoSuchAlgorithmException, CertificateException, IOException {
		if (url == null) {
			throw new IllegalArgumentException("Keystore url may not be null");
		}
		log.debug("Initializing key store : " + url + " (type " + keystoreType
				+ ")");
		KeyStore keystore = KeyStore.getInstance(keystoreType);
		keystore.load(url.openStream(),
				password != null ? password.toCharArray() : null);
		return keystore;
	}

	/**
	 * Builds a list of {@link KeyManager} from the default
	 * {@link KeyManagerFactory}.
	 *
	 * @param keystore
	 *            The keystore that holds certificats
	 * @param password
	 *            Keystore password
	 * @see KeyManagerFactory#getKeyManagers()
	 * @see KeyManagerFactory#getInstance(String)
	 * @see KeyManagerFactory#getDefaultAlgorithm()
	 */
	public static KeyManager[] createKeyManagers(final KeyStore keystore,
			final String password) throws KeyStoreException,
			NoSuchAlgorithmException, UnrecoverableKeyException {
		if (keystore == null) {
			throw new IllegalArgumentException("Keystore may not be null");
		}
		log.debug("Initializing key manager");
		KeyManagerFactory kmfactory = KeyManagerFactory
				.getInstance(KeyManagerFactory.getDefaultAlgorithm());
		kmfactory.init(keystore, password != null ? password.toCharArray()
				: null);
		return kmfactory.getKeyManagers();
	}

	/**
	 * Builds a list of {@link TrustManager} from the default
	 * {@link TrustManagerFactory}.
	 *
	 * @param keystore
	 *            Le keystore contenant les certificats
	 * @see TrustManagerFactory#getInstance(String)
	 * @see TrustManagerFactory#getTrustManagers()
	 */
	public static TrustManager[] createTrustManagers(final KeyStore keystore)
			throws KeyStoreException, NoSuchAlgorithmException {
		if (keystore == null) {
			throw new IllegalArgumentException("Keystore may not be null");
		}
		log.debug("Initializing trust manager");
		TrustManagerFactory tmfactory = TrustManagerFactory
				.getInstance(TrustManagerFactory.getDefaultAlgorithm());
		tmfactory.init(keystore);
		TrustManager[] trustmanagers = tmfactory.getTrustManagers();
		for (int i = 0; i < trustmanagers.length; i++) {
			if (trustmanagers[i] instanceof X509TrustManager) {
				trustmanagers[i] = (X509TrustManager) trustmanagers[i];
			}
		}
		return trustmanagers;
	}

}
```


## Related links

- [IBM 32-bit SDK for Windows, Java 2 Technology Edition, Version 1.4.2 - Security Guide](http://www.ibm.com/developerworks/java/jdk/security/142/secguides/securityguide.win32.html)
- [IBM security providers: An overview](http://www.ibm.com/developerworks/java/library/j-ibmsecurity/index.html)
- [SSL handshake problems at developerWorks](https://www.ibm.com/developerworks/forums/thread.jspa?messageID=14778991&#14778991)
- [HttpClient SSL Guide](http://hc.apache.org/httpclient-3.x/sslguide.html)
- [Keystore Explorer](http://www.lazgosoftware.com/kse/) (helped me a lot)
