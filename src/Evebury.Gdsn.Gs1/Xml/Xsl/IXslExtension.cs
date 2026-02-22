namespace Evebury.Gdsn.Gs1.Xml.Xsl
{
    /// <summary>
    /// Interface for binding xsl extension object methods
    /// </summary>
    public interface IXslExtension
    {
        /// <summary>
        /// The namespace of the xsl extension methods
        /// </summary>
        string NamespaceUri { get; }
    }
}
