using System.Security.Cryptography;

namespace Evebury.Gdsn.Gs1.Xml.Compare.Canonical
{
    internal interface ICanonicalNode
    {
        void WriteHash(HashAlgorithm hash, XmlPointer pointer, XmlNamespaceContext context);
    }
}
