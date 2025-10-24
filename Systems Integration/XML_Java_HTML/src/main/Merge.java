package main;

import java.io.File;
import java.io.IOException;

import org.xml.sax.SAXException;

import generated.Catalog;
import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.JAXBException;
import jakarta.xml.bind.Marshaller;
import jakarta.xml.bind.Unmarshaller;

public class Merge
{

	public static void main(String[] args) throws SAXException, IOException
	{
		try
		{
			// Carregar o conteúdo do arquivo input_filter.xml
			JAXBContext inputContext = JAXBContext.newInstance(Catalog.class);
			Unmarshaller inputUnmarshaller = inputContext.createUnmarshaller();
			Catalog inputCatalog = (Catalog) inputUnmarshaller.unmarshal(new File("input_filter.xml"));

			// Carregar o conteúdo do arquivo estatisticas.xml
			JAXBContext statsContext = JAXBContext.newInstance(Catalog.class);
			Unmarshaller statsUnmarshaller = statsContext.createUnmarshaller();
			Catalog statsCatalog = (Catalog) statsUnmarshaller.unmarshal(new File("statistics.xml"));

			// Combinar os dados dos dois catalogos
			inputCatalog.setStatistics(statsCatalog.getStatistics());

			// Criar um novo arquivo XML combinando os dados
			JAXBContext mergeContext = JAXBContext.newInstance(Catalog.class);
			Marshaller marshaller = mergeContext.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);
			marshaller.marshal(inputCatalog, new File("merged.xml"));
			Selector.validate_xml("merged.xml","output_merged.xsd");
			System.out.println("Os arquivos foram combinados com sucesso em merged.xml.");
		}
		catch (JAXBException e)
		{
			e.printStackTrace();
			System.out.println("Ocorreu um erro ao combinar os arquivos de filtros e estatisticas.");
		}
		
		catch (IOException e)
		{
			System.out.print("O ficheiro xml e invalido!");
		}
	}

}
