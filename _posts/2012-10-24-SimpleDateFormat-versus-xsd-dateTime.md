---
layout: post
date: 2012-10-24 17:47:21 +0100
permalink: articles/simpledateformat-versus-xsddatetime
title: SimpleDateFormat versus xsd:dateTime
tags: dateTime java SimpleDateFormat time zone XML Schema XSD
---
## Time zones in XML Schema and Java

For interoperability reasons, it often makes sense for applications to transmit dates and times as **xsd:dateTime** strings, as this standard should serve all common cases.

_XML Schema_'s _dateString_ type was inspired by the extended syntax of _ISO 8601_ : a sample string would be `2000-03-04T23:00:00.000+03:00` (March 4th, 2000, 11:00:00 PM in a time zone that's 3 hours after UTC).

> ISO 8601 also defines another (more compact) syntax : `aaaammqqThhmissnzzzzz` (e.g. "19970716T1920304+0100") and other options like the week number and comma instead of dot, but they are not used in XML Schema.


## Dealing with XSD dateTime in Java

In Java, there are several ways to deal with an _XML Schema dateTime_.

### JDK 6

Since JDK 6 (JAXB 1.0), the preferred way is to use _DatatypeConverter_ :

```java
Calendar cal = DatatypeConverter.parseDateTime("1997-07-16T19:20:30.447+01:00");    // reads from an XSD string
String xsdDateStringAgain = DatatypeConverter.printDateTime(cal);                   // transforms back into an XSD string
```

### JDK 5 and less

Before JDK 6, one would be tempted to use _SimpleDateFormat_ :

```java
DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");         // attempts to defines my date in an XSD-compatible format
Date myDate = dateFormat.parse("1997-07-16T19:20:30.447+01:00");                    // reads from an XSD string
String myDateString = dateFormat.format(myDate);                                    // transforms back into an XSD string
```

Unfortunately, this code doesn't work because the `Z` pattern generates time zones in _RFC 822_'s format (`+HHMM`).
So parsing the generated string (`1997-07-16T19:20:30,4+0100`) would trigger an error because there is a colon missing in the timezone to conform to the _xsd:dateTime_ syntax.

One may notice that JDK 7's _SimpleDateFormat_ has a new `X` pattern for time zones in ISO 8601's extended syntax, so we might use the following format :

```java
DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSX");         // an XSD-compatible format
```

But as said in the previous chapter, since JDK 6 there is already a better alternative for _xsd:dateTime_ : _DatatypeConverter_.

If you really have to deal with pre-JDK 6 date strings formats (for instance with Logback's `<timestamp>`) you may use a combination of custom _SimpleDateFormat_ formats and _DatatypeConverter_ if available, but be aware that the time zone often gets simplified in the operation.

```java
DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
Date dt = dateFormat.parse("1997-07-16T19:20:30.447+0100");
System.out.println(dateFormat.format(dt));                                          // prints "1997-07-16T18:20:30.447+0000"

Calendar cal = Calendar.getInstance();
cal.setTime(dt);
System.out.println(DatatypeConverter.printDateTime(cal));                           // prints "1997-07-16T18:20:30.447Z"
```

So finally, if you want to keep as close as possible as the original string, you might draw inspiration from the following regular expression : `(.{19}(?:\.\d+)?[+-])(\d{2})(\d{2})`. It matches 3 groups :

1. the beginning of the string up to milliseconds (19 first chars = yyyy-MM-dd'T'HH:mm:ss + milliseconds if present)
2. time zone's hours
3. time zone's minutes

The following code snippet shows a sample usage of this pattern by transforming a string with a RFC 822 time zone into an XSD-compatible one :

```java
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
* Transforms the time zone generated with a 'Z' pattern from JDK 6 and older into an <tt>xsd:dateTime</tt> time
* zone.
*
* <p>
* For instance :
* <code>fixRfc822TimeZone("1997-07-16T19:20:30.447+0100") = "1997-07-16T19:20:30.447+01<em>:</em>00"</code>
* </p>
*
* @param rfc822
* A date/time string that matches {@link SimpleDateFormat}'s format "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
* @return A new string that matches <a href="http://www.w3.org/TR/xmlschema-2/#dateTime-timezones">XML Schema
* dateTime</a> syntax
*/
public static String fixRfc822TimeZone(String rfc822) {

// This pattern extracts 3 groups :
// 1. the beginning of the string up to milliseconds (19 first chars = yyyy-MM-dd'T'HH:mm:ss + milliseconds if present)
// 2. time zone's hours
// 3. time zone's minutes
Pattern pt = Pattern.compile("(.{19}(?:\\.\\d+)?[+-])(\\d{2})(\\d{2})");
Matcher m = pt.matcher(rfc822);
if (m.matches() && m.groupCount() == 3) {
String start = m.group(1);
String tzh = m.group(2);
String tzm = m.group(3);
// we simply add the missing colon ':' to comply to XSD
return start + tzh + ":" + tzm;
}

throw new IllegalArgumentException("Input string does not match '" + pt.pattern() + "' pattern");
}
```


Here is a recap of the different standards used by XSD and Java :

- XML Schema 2.0 was inspired by _ISO 8601:2000 Second Edition_'s extended syntax (e.g. "-08:00")
- _SimpleDateFormat_'s `Z` pattern refers to RFC 822 (e.g. "-0800")
- since JDK 7, _SimpleDateFormat_ has also an `X` pattern for _ISO 8601_ (e.g. "-08:00", "-0800", "-08")

In practice, there is just a dash more in ISO 8601 than in RFC 822, but before JDK 7 the programmer had to deal with it.

There is also a possible confusion because ISO 8601 allows the use of `Z` as a replacement for `+00:00`, whereas the same `Z` has a different meaning in _SimpleDateFormat_ : it matches _RFC 822_ time zone syntax (`+0000` without colon).

To generate an XSD String in UTC with the symbolic `Z` time zone, simply quote it : `new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")`.


### Another example : Logback

_Logback_ uses _SimpleDateFormat_ to format dates, so the pattern `%d{yyyy-MM-dd'T'HH:mm:ss.SSSX}` will only work on JDK7 and fail on JDK6 :

    09:58:31,716 |-WARN in ch.qos.logback.classic.pattern.DateConverter@1878144 - Could not instantiate SimpleDateFormat with pattern yyyy-MM-dd'T'HH:mm:s
    s.SSSX java.lang.IllegalArgumentException: Illegal pattern character 'X'
            at java.lang.IllegalArgumentException: Illegal pattern character 'X'


## References

- SimpleDateFormat (JDK 6) - [docs.oracle.com/javase/6/docs/api/java/text/SimpleDateFormat.html](http://docs.oracle.com/javase/6/docs/api/java/text/SimpleDateFormat.html)
- SimpleDateFormat (JDK 7) - [docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html](http://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html)
- DatatypeConverter - [docs.oracle.com/javase/6/docs/api/javax/xml/bind/DatatypeConverter.html](http://docs.oracle.com/javase/6/docs/api/javax/xml/bind/DatatypeConverter.html)
- RFC 822 time zone - [ietf.org/rfc/rfc0822.txt](http://www.ietf.org/rfc/rfc0822.txt) (see the syntax for "zone" in chapter "date and time specification")
- ISO 8601 time zone - [w3.org/TR/NOTE-datetime](http://www.w3.org/TR/NOTE-datetime)
- ISO 8601 (Wikipedia[fr] article) - [fr.wikipedia.org/wiki/ISO_8601](http://fr.wikipedia.org/wiki/ISO_8601)
- XML Schema (timezones) - [w3.org/TR/xmlschema-2/#dateTime-timezones](http://www.w3.org/TR/xmlschema-2/#dateTime-timezones)
- Logback Uniquely named files (by timestamp) - [logback.qos.ch/manual/appenders.html#uniquelyNamed](http://logback.qos.ch/manual/appenders.html#uniquelyNamed)
