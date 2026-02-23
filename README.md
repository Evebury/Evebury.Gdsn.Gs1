# Evebury.Gdsn.Gs1

A comprehensive .NET library for validating GDSN GS1 messages. This engine acts as a pre-validation layer, ensuring data quality and compliance before messages are delivered to the GS1 Network.

## 🚀 Features
- **Reduce API Costs**: Prevent unnecessary calls and potential "rate limit" issues by catching errors early and locally.
- **UI**: Display custom friendly localized messages. 
- **Smart delta updates**: Compare the message with a last successful update. Prevent forwarding to the GS1 Network if unaltered.
- **Data Integrity**: Ensure 100% compliance with GS1 XML schemas and complex business rules. If the message does not comply do not forward to the GS1 Network.
- **Operational Efficiency**: Use advanced responses with XPaths to pinpoint data errors instantly, reducing manual troubleshooting time.

## 📊 Supported Gdsn GS1 Messages

| Message                                      | Version  | Schema | Equality | Rules* |
|----------------------------------------------|----------|--------|----------|-------|
| `catalogueItemNotificationMessage`           | 3.1      | ✅     | ✅      | ⚠️    |
| `gS1ResponseMessage`                         | 3.1      | ✅     | ✅      |       |
| `catalogueItemHierarchicalWithdrawalMessage` | 3.1      | ✅     | ✅      |       |
| `catalogueItemPublicationMessage`            | 3.1      | ✅     | ✅      |       |
| `catalogueItemConfirmationMessage`           | 3.1      | ✅     | ✅      |       |
| `catalogueItemRegistrationResponseMessage`   | 3.1      | ✅     | ✅      |       |
| `catalogueItemSubscriptionMessage`           | 3.1      | ✅     | ✅      |       |

*\* if not indicated rules do not apply for this message type*

## 🔧 Current status catalogueItemNotificationMessage
- **Rules to be implemented**:  467 out of 1079.
- **Rules that should be a schema validation**:  541, 542, 1061
- **Rules that are not specified correctly by GS1**: 550, 633, 1013

## 🎯 Quick Start

```csharp
using Evebury.Gdsn.Gs1;
using System.Globalization;
using System.Xml;

// set the cultureinfo for localized messages in the reponse
CultureInfo cultureInfo = new("nl");

// Load the message
XmlDocument message = new();
message.Load("catalogueItemNotificationMessage.xml");

// Load optional previously sucessfuly published message
XmlDocument previous = new();
previous.Load("catalogueItemNotificationMessageLastSucceeded.xml");

// Create the validator
Gs1Validator validator = new();

//this call will apply schema, compare and apply business rules
Response response = validator.Validate(message, previous, cultureInfo);

// Check if OK or ERROR
Console.WriteLine(response.Status == StatusType.OK);

```
## 🏗️ Architecture

### Core Components

- **`Response`** - The response to all message operations
- **`Gs1Validator`** - Validator for all message validations

### Response
```csharp
//if true response was rendered before actual delivery to the GS1 Network.
bool isValidationResponse = response.IsValidationResponse;

//use ToJson(), ToXmlDocument() or ToXhtml(CultureInfo cultureInfo = null, string iFormat = null) to process the response in your application

```

## 📋 Requirements & Enterprise support

- **.NET 10.0** or later
- **Memory**: Varies on the message size. Schema, Extension and Rules will be cached but can be reset by clearing the buffer.
- **Dependencies**: None (pure .NET implementation)
> ### 💡 Need a different version?
> While we target .NET 10 for maximum performance, we provide **custom builds and integration support** for organizations running on **any other Framework**.
> [Contact evebury for custom builds or professional services](https://www.evebury.com)

## 🐛 Error Handling

The library provides specific exceptions for common scenarios:

- `MessageException`: The message is not valid for current operation.
- `ArgumentNullException`: Message can not be null

## ℹ️ Help
> Want to learn more about **GDSN GS1** or syndicating your data to **GS1**? Or anything else? We would love to hear from you! Reach out to us at: [Evebury](https://www.evebury.com).


## 📄 License

This project is licensed under the MIT License - see below for details:

```
MIT License

Copyright (c) 2026 Evebury

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

*This library implements the GDSN GS1 specification with focus on practical syndication applications.*
