using System;
using System.Xml;

namespace Evebury.Gdsn.Gs1.Message
{
    internal struct MessageKey(string message, string element, string nameSpaceUri, int version, MessageType type) : IEquatable<MessageKey>
    {
        public static MessageKey CatalogueItemNotification3 => GetKey("catalogueItemNotificationMessage", "urn:gs1:gdsn:catalogue_item_notification:xsd:3", MessageType.CatalogueItem);
        public static MessageKey Gs1Response3 => GetKey("gS1ResponseMessage", "urn:gs1:gdsn:gs1_response:xsd:3", MessageType.CatalogueItem);
        public static MessageKey CatalogueItemPublication3 => GetKey("catalogueItemPublicationMessage", "urn:gs1:gdsn:catalogue_item_publication:xsd:3", MessageType.CatalogueItem);
        public static MessageKey CatalogueItemHierarchicalWithdrawal3 => GetKey("catalogueItemHierarchicalWithdrawalMessage", "urn:gs1:gdsn:catalogue_item_hierarchical_withdrawal:xsd:3", MessageType.CatalogueItem);
        public static MessageKey CatalogueItemConfirmation3 => GetKey("catalogueItemConfirmationMessage", "urn:gs1:gdsn:catalogue_item_confirmation:xsd:3", MessageType.CatalogueItem);
        public static MessageKey CatalogueItemRegistrationResponse3 => GetKey("catalogueItemRegistrationResponseMessage", "urn:gs1:gdsn:catalogue_item_registration_response:xsd:3", MessageType.CatalogueItem);
        public static MessageKey CatalogueItemSubscription3 => GetKey("catalogueItemSubscriptionMessage", "urn:gs1:gdsn:catalogue_item_subscription:xsd:3", MessageType.CatalogueItem);


        public string Message { get; set; } = message;
        public string Element { get; set; } = element;
        public string NamespaceUri { get; set; } = nameSpaceUri;
        public int Version { get; set; } = version;
        public MessageType Type { get; set; } = type;

        private static MessageType GetType(string namespaceUri) 
        {
            if (namespaceUri == CatalogueItemNotification3.NamespaceUri) return MessageType.CatalogueItem;
            if (namespaceUri == Gs1Response3.NamespaceUri) return MessageType.CatalogueItem;
            if (namespaceUri == CatalogueItemPublication3.NamespaceUri) return MessageType.CatalogueItem;
            if (namespaceUri == CatalogueItemHierarchicalWithdrawal3.NamespaceUri) return MessageType.CatalogueItem;
            if (namespaceUri == CatalogueItemConfirmation3.NamespaceUri) return MessageType.CatalogueItem;
            if (namespaceUri == CatalogueItemRegistrationResponse3.NamespaceUri) return MessageType.CatalogueItem;
            if (namespaceUri == CatalogueItemSubscription3.NamespaceUri) return MessageType.CatalogueItem;
            return MessageType.NotDefined;
        }

        private static MessageKey GetKey(string message, string namespaceUri, MessageType type) 
        {
            string element = message;
            if (element.EndsWith("Message")) element = element[..^7];
            int version = 0;
            if (namespaceUri.Contains(':'))
            {
                string namespaceVersion = namespaceUri[(namespaceUri.LastIndexOf(':') + 1)..];
                _ = int.TryParse(namespaceVersion, out version);
            }
            return new MessageKey(message, element, namespaceUri, version, type);
        }

        public static MessageKey GetKey(XmlDocument content)
        {
            string message = content.DocumentElement.LocalName;
            string namespaceUri = content.DocumentElement.NamespaceURI;
            MessageType type = GetType(namespaceUri);
            return GetKey(message, namespaceUri, type);
        }

        public override readonly string ToString()
        {
            return $"{Message} {NamespaceUri}";
        }

        public readonly bool Equals(MessageKey other)
        {
            return Message == other.Message && NamespaceUri == other.NamespaceUri && Version == other.Version && Type == other.Type;
        }

        public override readonly bool Equals(object obj)
        {
            return obj is MessageKey key && Equals(key);
        }

        public override readonly int GetHashCode()
        {
            return HashCode.Combine(Message, NamespaceUri);
        }

        public static bool operator ==(MessageKey obj, MessageKey other)
        {
            return Equals(obj, other);
        }

        public static bool operator !=(MessageKey obj, MessageKey other)
        {
            return !Equals(obj, other);
        }
    }
}
