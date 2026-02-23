using System.Security.Cryptography;
using System.Xml;

namespace Evebury.Gdsn.Gs1.Xml.Compare.Canonical
{
    internal class CanonicalXmlEntityReference(string name, XmlDocument xml) : XmlEntityReference(name, xml), ICanonicalNode
    {
        public void WriteHash(HashAlgorithm hash, XmlPointer pointer, XmlNamespaceContext context)
        {
           XmlWriter.WriteHashGenericNode(this, hash, pointer, context);
        }
    }
}
