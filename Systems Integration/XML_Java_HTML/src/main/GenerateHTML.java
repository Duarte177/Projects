package main;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStream;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import generated.Catalog;
import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.JAXBException;
import jakarta.xml.bind.Unmarshaller;
import jakarta.xml.bind.util.JAXBSource;

public class GenerateHTML
{
	// Metodo para passar ficheiro XML para HTML atraves do xsl
	private static void xmlTohtml(Catalog catalog, String xsl_source, String outputHTML) throws JAXBException, TransformerException, FileNotFoundException 
	{
		// Criar uma instancia do TransformerFactory usada para criar transformadores XML
		TransformerFactory tf = TransformerFactory.newInstance();
		
		// Carregar o arquivo XSLT
		Source xsl = new StreamSource(new File(xsl_source));
		
		// Criar um 'StreamSource' para o documento XML representado pelo objeto 'catalog'
        JAXBContext jc = JAXBContext.newInstance(Catalog.class);
        Source source = new JAXBSource(jc, catalog);
     		
        // Criar um transformador com base no arquivo XSLT 
     	Transformer transformer = tf.newTransformer(xsl);
		// Criar um arquivo HTML de saída onde o resultado da transformação sera salvo
		OutputStream htmlFile = new FileOutputStream(outputHTML);
		
		// Criar um 'StreamResult' para especificar que o resultado da transformação será salvo num arquivo HTML
     	StreamResult result = new StreamResult(htmlFile);

		// Aplicar as transformações definidas no arquivo XSLT ao documento XML representado pelo objeto 'catalog'
        // Gravar o resultado da transformação no arquivo HTML
		transformer.transform(source, result);	
	}

	public static void main(String[] args) throws FileNotFoundException, TransformerException 
	{
		File search_results = new File("merged.xml");
		JAXBContext jaxbContext = null;
		// Converter o XML filtrado para HTML, com base do XSL correspondente
		try
	    {
		     jaxbContext = JAXBContext.newInstance(Catalog.class);
		     Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
		     Catalog new_catalog = (Catalog) jaxbUnmarshaller.unmarshal(search_results);
		     
		     String output_html = "New_Catalog.html";    // output html
		     String xsl_filter = "file.xsl";      // ficheiro xsl
		     xmlTohtml(new_catalog, xsl_filter, output_html);
		     System.out.println("O ficheiro HTML foi criado com sucesso!");
	    }
	    catch (JAXBException e) 
	    {
	      e.printStackTrace();
	      System.out.println("Nao foi possivel converter o ficheiro XML para HTML");
	    }
	}
}
