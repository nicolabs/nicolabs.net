---
layout: post
date: 2013-02-25 13:33:16 +0100
title: Unicode essentials for Java
permalink: articles/unicode-essentials-java
tags:
  - internationalization
  - java
  - unicode
---
## Draft !
![Rosetta Stone + Unicode logo](/assets/blog/rosetta_unicode.jpg)

Today, all developers have heard of Unicode : this character encoding allows all characters of any language in the world.

This article outlines the basics of Unicode through some key points for **Java developers**.

It also talks about the influence of Unicode on the JVM, like how characters are stored into a `String` and why you have to get cautious when using `char` and `String.length()`.

## Unicode internals

### History and definitions

#### Supplementary characters

Unicode version 1 was designed to use a fixed size of 16 bits to store a character. Therefore, only 65536 characters could theorically be assigned : they make up the *Basic Multilingual Plane* (BMP).

Of course this revealed too small and Unicode version 2 added the concept of **supplementary characters** : those that would be encoded using more than 2 bytes, from `0x10000` to `0x10FFFF`. This would be enough to store the characters of all known languages.

Although already specified, the first *supplementary characters* were only assigned in Unicode 3.1.

#### Code Point

Each Unicode character is assigned a unique code from `0x0` to `0x10FFFF` : it's called a **code point**.

Unicode characters are then officially written `U+<codepoint in hexadecimal>`, i.e. the code point of the '*euro*' currency symbol ('`€`') is `U+20AC`.

### Encodings

Byte representation of Unicode characters is not straighforward : there are 3 possible encodings which differ in algorithm and *code unit* size used : UTF-32, UTF-16 and UTF-8.

Since Unicode's *encoding schemes* represent characters using a different of bytes, a *code unit* was defined as the minimal bit combination that can represent a unit of encoded text.

#### UTF-32

UTF-32 is the simplest encoding : it stores the *code point* value of each character in a 32-bits sequence.

Since Unicode maps characters up to `U+10FFFF`, only 21 out of the 32 bits are significants and values beyond `0x10FFFF` are ill-formed. Also, values from `0xD800` to `0xDFFF` are reserved for UTF-16 (see next chapter).

Because it uses 4 bytes for each character, UTF-32 is the most memory-expensive Unicode encoding.

#### UTF-16

UTF-16 uses 2 or 4 bytes for each character (= 1 or 2 UTF-16 code units), depending on the character.

Characters in the *Basic Multilingual Plane* (the ones up to `U+FFFF`) are represented with their code point as a 16-bits value (2 bytes), as prescribed by Unicode v1.
Supplementary characters are represented with a *surrogate pair* (4 bytes) :

> A **surrogate pair** is a pair of 16-bits code units where the first value of the pair is a **high surrogate** and the second value is a **low surrogate**. High surrogates range from `U+D800` to `U+DBFF` and low surrogates from `U+DC00` to `U+DFFF`. Therefore, surrogates code units range from `U+D800` to `U+DBFF`.

Surrogate values are reserved for UTF-16 encoding and do not map to any character.
Therefore, when an UTF-16 *code unit* starts with a value within `0xD800` to `0xDFFF`, it always represents the first part of a Unicode supplementary character.

For instance the Unicode sequence [`U+004D`, `U+0430`, `U+4E8C`, `U+10302`] would be represented by the following UTF-16 bytes sequence : [`0x004D`, `0x0430`, `0x4E8C`, `0xD800`, `0xDF02`] where the surrogate pair [`0xD800`, `0xDF02`] represents the character `U+10302`.

#### UTF-8

UTF-8 uses 1, 2, 3 or 4 bytes for each character, segmenting them in several ranges :

- `U+0000` to `U+007F` are encoded with a single byte
- `U+0080` to `U+07FF` with 2 bytes
- `U+0800` to `U+FFFF` with 3 bytes
- `U+10000` to `U+10FFFF`  with 4 bytes

Have you noticed that the first range corresponds to the ASCII character set ? This makes **UTF-8 compliant with the ASCII charset**.

Since ASCII characters are encoded with 7 bits only, every byte in an UTF-8 sequence that starts with a 0 bit can be identified as an ASCII character. Other bytes (from 0x80) belong to other ranges and therefore map to character using at least 2 bytes.

The real segmentation is more complex as it takes into account other conditions (i.e. the reserved range for UTF-16 surrogates). The list of well-formed UTF-8 byte sequences is summed in two tables that you will find in [chapter 3.9 "Unicode Encoding Forms" of the Unicode Standard](http://www.unicode.org/versions/Unicode6.2.0/ch03.pdf#G28070).

Funnily (but for reasons), this encoding implies that you will never find the following bytes in an UTF-8 sequence : `0xC0`, `0xC1`, `0xF5`..`0xFF` !

#### Alltogether

Even though the different Unicode encoding schemes take care of not interfering with each other, a character will not generally have the same byte representation in a all encodings :

Sample code units in different encodings

- Unicode character :	`U+10400`
- UTF-32 encoding   :	`[0x00010400]`
- UTF-16 encoding   :	`[0xD801, 0xDC00]`
- UTF-8 encoding    :	`[0xF0, 0x90, 0x90, 0x80]`

## Unicode in the Java SDK

### Unicode representation in the JVM

> TODO blabbla so it was decided that :

- Use the primitive type `int` to represent code points in low-level APIs, such as the static methods of the `Character` class.
- Interpret `char` sequences in all forms as UTF-16 sequences, and promote their use in higher-level APIs.
- Provide APIs to easily convert between various `char` and code point-based representations.

### The char primitive type

In Java, a `char` is always stored on 2 bytes. It was a design decision from the first Java specification, and although Unicode has introduced supplementary characters since then, [it has been decided not to change this](http://www.oracle.com/technetwork/java/supplementary-142654.html) because it was too much anchored with the core JVM.

As a result, it is not possible to store supplementary characters in a `char` in Java.
Trying to do so will result in a compilation error.

### Code points

In Java a 32-bits value is used to store code points, even though only 21 bits out of the 32 are significant.

### Classes and methods

> TODO

### Properties

> TODO

## Java best practices

The Java tutorial ends with [a series of recommandations for application design](http://docs.oracle.com/javase/tutorial/i18n/text/design.html), regarding Unicode handling.

The most useful one is probably to replace [`String.length`](http://docs.oracle.com/javase/7/docs/api/java/lang/String.html#length%28%29) with [`String.codePointCount`](http://docs.oracle.com/javase/7/docs/api/java/lang/String.html#codePointCount%28int,%20int%29) when it is likely to receive *supplementary characters*.

```java
String string = "aÃ\uD840\uDC00";
System.out.println(String.format("string=[%s]", string));
// prints string=[aÃ ð €€]

System.out.println("length=" + string.length());
// prints length=4

System.out.println("codePointCount=" + string.codePointCount(0, string.length()));
// prints codePointCount=3

for (char car : string.toCharArray()) {
    System.out.print(String.format("%x ", (int) car));
}
// prints 61 e0 d840 dc00
System.out.println();

for (char car : string.toCharArray()) {
    System.out.print(Character.isHighSurrogate(car) ? "h" : Character.isLowSurrogate(car) ? "l" : "?");
}
// prints ??hl
System.out.println();
```

### HTML notation

> TODO

[en.wikipedia.org/wiki/Numeric_character_references](https://en.wikipedia.org/wiki/Numeric_character_references) (ex: `&#x03A3;`)



## No charset for Servlets

As a sample of internationalization issues (which are numerous), this chapter points out one common failure in the HTTP ecosystem.

When submitting a form, most browsers do not set the HTTP header "`Content-Encoding`", even if the encoding is correctly set in the page / form (confirmed with Chrome 26 and Firefox 12).
Besides this, HTTP servers cannot always guess the charset encoding of the content they serve : they must be statically configured.

> Nor `<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">` neither `<form accept-charset="UTF-8" ...>` will help you get an encoding at the end of the chain...

As a result, don't count on getting a charset encoding from a ServletRequest.

> `servletRequest.getCharacterEncoding() == null // most of the time`
[docs.oracle.com/javaee/6/api/javax/servlet/ServletRequest.html#setCharacterEncoding(java.lang.String)](http://docs.oracle.com/javaee/6/api/javax/servlet/ServletRequest.html#setCharacterEncoding(java.lang.String))

You will find several methods to circumvent this on the net, but probably not a good one...

For its simplicity, the following method might be worth noting :

```java
@Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
log.debug("CharacterEncoding before = {}", req.getCharacterEncoding());
// Set this before any access to the request parameters
req.setCharacterEncoding("UTF-8");
log.debug("CharacterEncoding forced = {}", req.getCharacterEncoding());

// TODO Read parameters...
log.info("myUnicodeParameter={}", req.getParameter("myParameter"));
}
```

Hope this helps...

* UTF-8: The Secret of Character Encoding - [htmlpurifier.org/docs/enduser-utf8.html](http://htmlpurifier.org/docs/enduser-utf8.html)
* Tomcat : [wiki.apache.org/tomcat/FAQ/CharacterEncoding](http://wiki.apache.org/tomcat/FAQ/CharacterEncoding)
* GlassFish : [docs.oracle.com/cd/E19798-01/821-1752/beafw/index.html](http://docs.oracle.com/cd/E19798-01/821-1752/beafw/index.html)





Java™ Servlet Specification Version 3.0 :

> 3.10 Request data encoding
> Currently, many browsers do not send a char encoding qualifier with the Content-
Type header, leaving open the determination of the character encoding for reading
HTTP requests. The default encoding of a request the container uses to create the
request reader and parse POST data must be “ISO-8859-1” if none has been specified
by the client request. However, in order to indicate to the developer, in this case, the
failure of the client to send a character encoding, the container returns null from
the getCharacterEncoding method.
28 Java Servlet Specification • November 2009
If the client hasn’t set character encoding and the request data is encoded with a
different encoding than the default as described above, breakage can occur. To
remedy this situation, a new method setCharacterEncoding(String enc) has
been added to the ServletRequest interface. Developers can override the
character encoding supplied by the container by calling this method. It must be
called prior to parsing any post data or reading any input from the





### Byte order mark/Unicode sniffing

> ***Wikipedia*** : For both serializations of HTML (content-type "text/html" and content/type "application/xhtml+xml"), the Byte order mark (BOM) is an effective way to transmit encoding information within an HTML document. For UTF-8, the BOM is optional, while it is a must for the UTF-16 and the UTF-32 encodings. (Note: UTF-16 and UTF-32 without the BOM are formally known under different names, they are different encodings, and thus needs some form of encoding declaration – see UTF-16BE, UTF-16LE, UTF-32LE and UTF-32BE.) The use of the BOM character (`U+FEFF`) means that the encoding automatically declares itself to any processing application. Processing applications need only look for an initial 0x0000FEFF, 0xFEFF or 0xEFBBBF in the byte steam to identify the document as UTF-32, UTF-16 or UTF-8 encoded respectively. No additional metadata mechanisms are required for these encodings since the byte-order mark includes all of the information necessary for processing applications. In most circumstances the byte-order mark character is handled by editing applications separately from the other characters so there is little risk of an author removing or otherwise changing the byte order mark to indicate the wrong encoding (as can happen when the encoding is declared in English/Latin script). If the document lacks a byte-order mark, the fact that the first non-blank printable character in an HTML document is supposed to be "<" (`U+003C`) can be used to determine a UTF-8/UTF-16/UTF-32 encoding.

## References

- The Java Tutorials (chapter "Unicode") - [docs.oracle.com/javase/tutorial/i18n/text/unicode.htm](http://docs.oracle.com/javase/tutorial/i18n/text/unicode.htm)
- Class Character - [docs.oracle.com/javase/7/docs/api/java/lang/Character.html#unicode](http://docs.oracle.com/javase/7/docs/api/java/lang/Character.html#unicode)
- Supplementary Characters in the Java Platform - [oracle.com/technetwork/java/supplementary-142654.html](http://www.oracle.com/technetwork/java/supplementary-142654.html)
- The Java Language Specification (notes for Unicode) - [docs.oracle.com/javase/specs/jls/se7/html/jls-3.html#jls-3.1](http://docs.oracle.com/javase/specs/jls/se7/html/jls-3.html#jls-3.1)
- Hypertext Transfer Protocol -- HTTP/1.1 (seek for Content-Type) - [ietf.org/rfc/rfc2616.txt](http://www.ietf.org/rfc/rfc2616.txt)
- Internationalization (I18n), Localization (L10n), Standards, and Amusements - [i18nguy.com/surrogates.html](http://www.i18nguy.com/surrogates.html)
- The Unicode Consortium - [unicode.org](http://www.unicode.org)
- Unicode Character Code Charts - [unicode.org/charts](http://www.unicode.org/charts)
- Glossary of Unicode Terms - [unicode.org/glossary](http://www.unicode.org/glossary)
- Core Specification, chapter 3 "Conformance" - [unicode.org/versions/Unicode6.2.0/ch03.pdf#G28070](http://www.unicode.org/versions/Unicode6.2.0/ch03.pdf#G28070)
- Unicode and HTML (Wikipedia) - [en.wikipedia.org/wiki/Unicode_and_HTML](https://en.wikipedia.org/wiki/Unicode_and_HTML)
- Handling character encodings in HTML and CSS - [w3.org/International/tutorials/tutorial-char-enc](http://www.w3.org/International/tutorials/tutorial-char-enc)
- Character Encoding Issues (Tomcat Wiki) - [wiki.apache.org/tomcat/FAQ/CharacterEncoding](http://wiki.apache.org/tomcat/FAQ/CharacterEncoding)
- Java Servlet specification version 3.0 (JSR 315) - [jcp.org/en/jsr/detail?id=315](http://jcp.org/en/jsr/detail?id=315)
- UTF-8: The Secret of Character Encoding - [htmlpurifier.org/docs/enduser-utf8.html](http://htmlpurifier.org/docs/enduser-utf8.html)
- UniView (lookup and display Unicode characters) - [rishida.net/scripts/uniview/](http://rishida.net/scripts/uniview/)
