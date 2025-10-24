<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/catalog">
    <html>
      <head>
        <title>Researcher Catalog</title>
      </head>
      <body>
        <h1>Researchers Catalog</h1>
        <xsl:apply-templates select="researchers"/>
        <xsl:apply-templates select="statistics"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="researchers">
    <div class="researcher">
      <h1><xsl:value-of select="name"/></h1>
      <p><strong>Areas of activity:</strong> <xsl:value-of select="area"/></p>
      <p><strong>Affiliations:</strong>
        <xsl:for-each select="affiliation">
          <xsl:value-of select="."/>
          <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
      </p>
      <p><strong>Interests:</strong>
        <ul>
          <xsl:for-each select="research_interests/interest">
            <li><xsl:value-of select="."/></li>
          </xsl:for-each>
        </ul>
      </p>
      <p><strong>Email:</strong> <a href="mailto:{email}"><xsl:value-of select="email"/></a></p>
      <p><strong>Number of articles:</strong> <xsl:value-of select="number_articles"/></p>
      <h1>Publications:</h1>
      <xsl:apply-templates select="publications"/>
    </div>
  </xsl:template>

  <xsl:template match="publications">
    <div class="publication">
 	 
      <h2><xsl:value-of select="title"/></h2>
      <p><strong>Date:</strong> <xsl:value-of select="date"/></p>
      <p><strong>Number of citations:</strong> <xsl:value-of select="citation"/></p>
      <p><strong>Co-authors:</strong>
       <xsl:for-each select="co_authors/author">
          <xsl:value-of select="."/>
          <xsl:if test="position() != last()">, </xsl:if>
       </xsl:for-each>
      </p>
      
      <xsl:if test="publication_source/source">
 		<p><strong>Source:</strong> <xsl:value-of select="publication_source/source"/></p>
	  </xsl:if>
      
      <xsl:if test="publication_source/conference">
 		<p><strong>Conference:</strong> <xsl:value-of select="publication_source/conference"/></p>
	  </xsl:if>
      
      <xsl:if test="publication_source/journal">
 		<p><strong>Journal:</strong> <xsl:value-of select="publication_source/journal"/></p>
	  </xsl:if>
      
      <xsl:if test="publication_source/book">
 		<p><strong>Book:</strong> <xsl:value-of select="publication_source/book"/></p>
	  </xsl:if>
      
      <xsl:if test="publication_source/volume">
 		<p><strong>Volume:</strong> <xsl:value-of select="publication_source/volume"/></p>
	  </xsl:if>
      
      <xsl:if test="publication_source/issue">
 		<p><strong>Issue:</strong> <xsl:value-of select="publication_source/issue"/></p>
	  </xsl:if>
      
  	  <xsl:if test="publication_source/pag_min and publication_source/pag_max">
 		<p><strong>Pages:</strong> <xsl:value-of select="publication_source/pag_min"/> - <xsl:value-of select="publication_source/pag_max"/></p>
	  </xsl:if>

	  <xsl:if test="publisher">
 		<p><strong>Publisher:</strong> <xsl:value-of select="publisher"/></p>
	  </xsl:if>
	  
	  <xsl:if test="description">
 		<p><strong>Description:</strong> <xsl:value-of select="description"/></p>
	  </xsl:if>
	 
        <p>-------------------------------------------------------------------------------------------------------------------------------------------------------------------------</p>
    </div>
  </xsl:template>
  
  <xsl:template match="statistics">
  <div class="stats">
     <h1>Statistics</h1>
     
     <xsl:if test="numberResearchers">
     	<p><strong>Number of researchers:</strong><xsl:value-of select="numberResearchers"/></p>
	 </xsl:if>
	 
	 <xsl:if test="numberJournals">
     	<p><strong>Number of journals:</strong><xsl:value-of select="numberJournals"/></p>
	 </xsl:if>
	 
	 <xsl:if test="numberConferences">
     	<p><strong>Number of conferences:</strong><xsl:value-of select="numberConferences"/></p>
	 </xsl:if>
	 
	 <xsl:if test="numberSources">
     	<p><strong>Number of sources:</strong><xsl:value-of select="numberSources"/></p>
	 </xsl:if> 
	 
	 <xsl:if test="numberBooks">
     	<p><strong>Number of books:</strong><xsl:value-of select="numberBooks"/></p>
	 </xsl:if>
	 
	 <xsl:if test="numberCitations">
     	<p><strong>Number of citations:</strong><xsl:value-of select="numberCitations"/></p>
	 </xsl:if>
	 <xsl:if test="title_stats">
     <p><strong>Titles with most citations</strong></p>
    	<ul>
        <xsl:for-each select="title_stats">
          <li>
            <xsl:value-of select="."/>
          </li>
        </xsl:for-each>
      </ul>
      </xsl:if>
  </div>
</xsl:template>
  
</xsl:stylesheet>