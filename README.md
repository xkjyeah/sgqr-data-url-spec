# Proposed specification for SGQR data URL

## Background

SGQR does not support deep linking today. That is, for any phone app or website that wants to offer PayNow, the user must follow
a unwieldy multistep process:

1. Download the payment QR code
2. Launch the banking app
3. Use the banking app to find the downloaded QR code
4. Complete payment using the banking app
5. Return to the website

To use a diagram I previously made:

![7 steps to pay with PayNow](images/paynow-steps.png)

## What makes deeplinking challenging?

Deep-linking for payment schemes have been around since at least 2017 with
UPI. UPI uses a deep-linking URL scheme that starts with `upi://pay?...`.

The problem is, unfortunately, iOS. For some bizarre reason, Apple does not
think that it's a good idea to allow multiple apps to share support for a URL
scheme. This means that, when you activate a URL like `upi://`, an arbitrary
application that supports UPI will be selected. It does not matter whether you
prefer Google Pay, PayTM or PhonePe -- the operating system will select a random one
of these apps.

To quote [Apple documentation](https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app) as of July 2025, "_If multiple apps register the same scheme, the app the system targets is undefined. There’s no mechanism to change the app or to change the order apps appear in a Share sheet._".

Note: Android has no such limitation.

So, this is obviously a big fuck-you to payment schemes like SGQR, where the
goal is to support an entire ecosystem of SGQR-supporting applications, not a
monopolistic endeavour like Apple Pay. (While UPI didn't exist back in 2010 when [this problem started to be noticed](https://stackoverflow.com/questions/3213911/choosing-what-iphone-app-must-open-one-url-schema), it doesn't make sense for
Apple to maintain this limitation in 2025).

In any case, whether this is Apple abusing their monopoly position in the premium
phone segment is a matter for RBI, ECB and other big regulators to decide. For me,
I'm just here to propose an alternative.

## The Specification

Here's the data inside a sample SGQR (00020101021126380009SG.PAYNOW010100211+6591234567030115204000053037025802SG5902NA6009Singapore6304B5DB).

Let's convert it to a data URL!

[Pay!](data:application/emv-qrcps-mpm+sgqr;base64,MDAwMjAxMDEwMjExMjYzODAwMDlTRy5QQVlOT1cwMTAxMDAyMTErNjU5MTIzNDU2NzAzMDExNTIwNDAwMDA1MzAzNzAyNTgwMlNHNTkwMk5BNjAwOVNpbmdhcG9yZTYzMDRCNURC)

<a href="data:application/emv-qrcps-mpm+sgqr;base64,MDAwMjAxMDEwMjExMjYzODAwMDlTRy5QQVlOT1cwMTAxMDAyMTErNjU5MTIzNDU2NzAzMDExNTIwNDAwMDA1MzAzNzAyNTgwMlNHNTkwMk5BNjAwOVNpbmdhcG9yZTYzMDRCNURC">Pay!</a>