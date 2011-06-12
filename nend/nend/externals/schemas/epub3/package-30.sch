<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    
    <ns uri="http://www.idpf.org/2007/opf" prefix="opf"/>
    <ns uri="http://purl.org/dc/elements/1.1/" prefix="dc"/>
            
    <pattern id="opf.uid">
        <rule context="opf:package[@unique-identifier]">
            <let name="uid" value="./@unique-identifier" />
            <assert test="/opf:package/opf:metadata/dc:identifier[@id = $uid]"
                >package element unique-identifier attribute does not resolve to a dc:identifier element (given reference was '<value-of select="$uid"/>')</assert>
        </rule>    
    </pattern>
    
    <pattern id="opf.itemref">        
        <rule context="opf:spine/opf:itemref[@idref]">    
            <let name="ref" value="./@idref" />            
            <let name="item" value="//opf:manifest/opf:item[@id = $ref]"/>
            <let name="item-media-type" value="$item/@media-type" />                                   
            <assert test="$item"
                >itemref element idref attribute does not resolve to a manifest item element</assert>
        </rule>    
    </pattern>
    
    <pattern id="opf.fallback.ref"> 
        <rule context="opf:item[@fallback]">
            <let name="ref" value="./@fallback" />
            <let name="item" value="/opf:package/opf:manifest/opf:item[@id = $ref]"/>
            <assert test="$item and $item/@id != ./@id"
                >manifest item element fallback attribute must resolve to another manifest item (given reference was '<value-of select="$ref"/>')</assert>
        </rule>            
    </pattern>
        
    <pattern id="opf.media.overlay"> 
        <rule context="opf:item[@media-overlay]">
            <let name="ref" value="./@media-overlay" />
            <let name="item" value="//opf:manifest/opf:item[@id = $ref]" />
            <let name="item-media-type" value="$item/@media-type" />
            <assert test="$item-media-type = 'application/smil+xml'"
                >media overlay items must be of the 'application/smil+xml' type (given type was '<value-of select="$item-media-type"/>')</assert>
        </rule>            
    </pattern>
    
    <pattern id="opf.media.overlay.metadata"> 
        <rule context="opf:manifest[opf:item[@media-overlay]]">
            <assert test="//opf:meta[@property='media:duration' and not (@about)]"
                >global media:duration meta element not set</assert>
        </rule>
        <rule context="opf:manifest/opf:item[@media-overlay]">
            <let name="mo-idref" value="@media-overlay"/>
            <let name="mo-item" value="//opf:item[@id = $mo-idref]"/>
            <let name="mo-item-id" value="$mo-item/@id"/>
            <let name="mo-item-uri" value="concat('#', $mo-item-id)"/>
            <assert test="//opf:meta[@property='media:duration' and @about = $mo-item-uri ]"
                >item media:duration meta element not set (expecting: meta property='media:duration' about='<value-of select="$mo-item-uri"/>')</assert>
        </rule>
    </pattern>
          
    <pattern id="opf.bindings.handler"> 
        <rule context="opf:bindings/opf:mediaType">
            <let name="ref" value="./@handler" />
            <let name="item" value="//opf:manifest/opf:item[@id = $ref]" />
            <let name="item-media-type" value="$item/@media-type" />
            <assert test="$item-media-type = 'application/xhtml+xml'"
                >manifest items referenced from the handler attribute of a bindings mediaType element must be of the 'application/xhtml+xml' type (given type was '<value-of select="$item-media-type"/>')</assert>
        </rule>            
    </pattern>
          
    <pattern id="opf.toc.ncx"> 
        <rule context="opf:spine[@toc]">
            <let name="ref" value="./@toc" />            
            <let name="item" value="/opf:package/opf:manifest/opf:item[@id = $ref]"/>
            <let name="item-media-type" value="$item/@media-type" />
            <assert test="$item-media-type = 'application/x-dtbncx+xml'"
                >spine element toc attribute must reference the NCX manifest item (referenced media type was '<value-of select="$item-media-type"/>')</assert>
        </rule>            
    </pattern>    
        
    <pattern id="opf.dc.override" abstract="true"> 
        <rule context="$dc">            
            <let name="ref" value="./@opf:override" />            
            <let name="meta" value="/opf:package/opf:metadata/opf:meta[@id = $ref]"/>
            <assert test="$meta/@property = '$prop'"
                >opf:override attribute on a <name /> element must resolve to a meta element with the equivalent dcterms property (given property was <value-of select="$meta/@property"/>)</assert>
        </rule>            
    </pattern>
    
    <pattern id="opf.dc.identifier.override" is-a="opf.dc.override">
        <param name="prop" value="dcterms:identifier"/>
        <param name="dc" value="/opf:package/opf:metadata/dc:identifier[@opf:override]"/>           
    </pattern>
    
    <pattern id="opf.dc.title.override" is-a="opf.dc.override">
        <param name="prop" value="dcterms:title"/>
        <param name="dc" value="/opf:package/opf:metadata/dc:title[@opf:override]"/>           
    </pattern>
    
    <pattern id="opf.dc.language.override" is-a="opf.dc.override">
        <param name="prop" value="dcterms:language"/>
        <param name="dc" value="/opf:package/opf:metadata/dc:language[@opf:override]"/>           
    </pattern>
    
    <pattern id="opf.scheme-datatype">
        <rule context="opf:meta[@property='scheme']">
            <assert test="@datatype">scheme property must include a datatype attribute.</assert>
            <assert test="@datatype='xsd:anyURI' or @datatype='xsd:string'">scheme property datatype must of the type 'xsd:string' or 'xsd:anyURI'.</assert>
        </rule>
    </pattern>
    
    <pattern id="opf.nav"> 
        <rule context="opf:manifest">            
            <let name="item" value="//opf:manifest/opf:item[@properties and (some $token in tokenize(@properties,' ') satisfies (normalize-space($token) eq 'nav'))]" />            
            <assert test="count($item) = 1"
                >Exactly one manifest item must declare the 'nav' property (number of 'nav' items: <value-of select="count($item)"/>).</assert>                            
        </rule> 
        <rule context="opf:manifest/opf:item[@properties and (some $token in tokenize(@properties,' ') satisfies (normalize-space($token) eq 'nav'))]">
            <assert test="@media-type = 'application/xhtml+xml'"
                >The manifest item representing the Navigation Document must be of the 'application/xhtml+xml' type (given type was '<value-of select="@media-type"/>')</assert>
        </rule>    
    </pattern>
    
    <pattern id="opf.cover-image"> 
        <rule context="opf:manifest">            
            <let name="item" value="//opf:manifest/opf:item[@properties and (some $token in tokenize(@properties,' ') satisfies (normalize-space($token) eq 'cover-image'))]" />            
            <assert test="count($item) &lt; 2"
                >Multiple occurrences of the 'cover-image' property (number of 'cover-image' items: <value-of select="count($item)"/>).</assert>                            
        </rule> 
    </pattern>
    
    <include href="./mod/id-unique.sch"/>     
         
         
    <!-- TODO
        meta element values, property dependant
        @profile, @prefix, and prefix resolution in meta/@property, check profile adherence and recognized unprefixed tokens        
    -->
    
</schema>