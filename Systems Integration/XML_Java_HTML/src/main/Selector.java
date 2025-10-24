package main;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.io.FileNotFoundException;

import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.xml.sax.SAXException;
import javax.xml.XMLConstants;

import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.TransformerException;

import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.JAXBException;
import jakarta.xml.bind.Marshaller;
import jakarta.xml.bind.Unmarshaller;

import generated.Catalog;
import generated.Researchers;
import generated.ResearchInterests;



public class Selector
{
	// Metodo de validar ficheiros XML partindo do XSD correspondente
	public static void validate_xml(String xml_file, String schema_file) throws SAXException, IOException
	{
		// Criar um SchemaFactory usando a constante XMLConstants.W3C_XML_SCHEMA_NS_URI
		SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
		// Carregar o ficheiro xsd
		Schema schema = schemaFactory.newSchema(new File(schema_file));
		// Criar um Validator com base no schema
		Validator validator = schema.newValidator();
		// Validar o ficheiro XML
		validator.validate(new StreamSource(new File(xml_file)));
	}

	
	
	public static void main(String[] args) throws FileNotFoundException, TransformerException 
	{
		Scanner scan = new Scanner(System.in);
		// Validar
		boolean booleanA;
		try
		{
			validate_xml("input.xml", "output.xsd");
			System.out.print("O ficheiro xml e valido!");
			booleanA = true;
		}
		catch (SAXException e)
		{
			System.out.print("O ficheiro xml e invalido!");
			booleanA = false;
		}
		catch (IOException e)
		{
			System.out.print("O ficheiro xml e invalido!");
			booleanA = false;
		}
				
		
		if (booleanA)
		{
			File xmlFile = new File("input.xml");
			JAXBContext jaxbContext = null;
		    Catalog catalog = null;

		    boolean booleanB = false;
		    try 
		    {
		      jaxbContext = JAXBContext.newInstance(Catalog.class);
		      Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
		      // Le e converte o arquivo xmlFile num objeto Java do tipo Catalog - catalog
		      catalog = (Catalog) jaxbUnmarshaller.unmarshal(xmlFile);
		      booleanB = true;
		    } 
		    catch (JAXBException e) 
		    {
		      e.printStackTrace();
		      System.out.print("Nao foi possivel converter o ficheiro xml num objeto Java");
		    }
		    
		    
		    
		    if(booleanB)
		    {
		    	ArrayList<Researchers> searchResult = new ArrayList<Researchers>();
		    	
			    boolean search_on = true;
			    while(search_on)
			    {
				    // Indice de pesquisa
					System.out.println("\n\n----------------- MENU DE PESQUISA -----------------");
					System.out.println(" (Escolhe qual o tipo de pesquisa que deseja fazer) ");
					System.out.println("----------------------------------------------------");
					System.out.println("1) Pesquisar por Afiliacao;");
					System.out.println("2) Pesquisar por Areas de Interesse;");
					System.out.println("3) Pesquisar por Areas de Formacao;");
					System.out.println("4) Ver Resultados");
					
					
					int search_option = 0;
					boolean booleanC = true;
					while (booleanC)
					{
						System.out.print("\nOPCAO:");
						
						if (scan.hasNextInt())
						{
							search_option = scan.nextInt();
							if (search_option < 5 && search_option > 0)
							{
								booleanC = false;
							}
							else
							{
								System.out.print("Opcao invalida. Escolha de 1) a 4)");
							}
							scan.nextLine();
						}
						else
						{
							
							System.out.print("Opcao invalida. Escolha de 1) a 4)");
							scan.nextLine();
						}
					}
					
					if(search_option==1)
					{
						System.out.print("\n\n»»»»»» AFILIACAO: ");
						String option_affiliation = scan.nextLine().toUpperCase();
						if (searchResult.isEmpty())
						{
							for (int i = 0; i < catalog.getResearchers().size(); i++)
							{
								List<String> all_affiliations = catalog.getResearchers().get(i).getAffiliation();
								for (String aff : all_affiliations) 
								{
									if (aff.toUpperCase().equals(option_affiliation)) 
									{
										searchResult.add(catalog.getResearchers().get(i));
									}
								}
							}
						}
						
						else 
						{
							ArrayList<Researchers> searchResult2 = new ArrayList<Researchers>();
							for (int i = 0; i < searchResult.size(); i++)
							{
								List<String> all_affiliations = searchResult.get(i).getAffiliation();
						        for (String aff : all_affiliations) 
						        {
						            if (aff.toUpperCase().equals(option_affiliation)) 
						            {
						                searchResult2.add(searchResult.get(i));
						            }
						        }
							}
							searchResult=searchResult2;
						}
					}
					
					else if(search_option==2)
					{
						System.out.print("\n\n»»»»»» AREA DE INTERESSE: ");
						String option_area = scan.nextLine().toUpperCase();
						
						if (searchResult.isEmpty())
						{
							for (int j = 0; j < catalog.getResearchers().size(); j++)
							{
								ResearchInterests all_interests = catalog.getResearchers().get(j).getResearchInterests();
						        for (int k = 0; k < all_interests.getInterest().size(); k++) 
						        {
						            if (all_interests.getInterest().get(k).toUpperCase().equals(option_area)) 
						            {
						                searchResult.add(catalog.getResearchers().get(j));
						            }
						        }
								
							}		
						}
						else
						{
							ArrayList<Researchers> searchResult2 = new ArrayList<Researchers>();
							for (int j = 0; j < searchResult.size(); j++)
							{
								ResearchInterests all_interests = searchResult.get(j).getResearchInterests();
						        for (int k = 0; k < all_interests.getInterest().size(); k++) 
						        {
						            if (all_interests.getInterest().get(k).toUpperCase().equals(option_area)) 
						            {
						                searchResult2.add(searchResult.get(j));
						            }
						        }
								
							}
							searchResult=searchResult2;
						}
					}
					
					else if(search_option==3)
					{
						System.out.print("\n\n»»»»»» AREA DE FORMACAO: ");
						String option_rarea = scan.nextLine().toUpperCase();
						
						if (searchResult.isEmpty()) 
						{
							for (int i = 0; i < catalog.getResearchers().size(); i++)
							{
								List<String> all_areas = catalog.getResearchers().get(i).getArea();
								for (String area : all_areas) 
								{
									if (area.toUpperCase().equals(option_rarea)) 
									{
										searchResult.add(catalog.getResearchers().get(i));
									}
								}
							}
						}
						else 
						{
							ArrayList<Researchers> searchResult2 = new ArrayList<Researchers>();
							for (int i = 0; i < searchResult.size(); i++)
							{
								List<String> all_areas = searchResult.get(i).getArea();
						        for (String area : all_areas) 
						        {
						            if (area.toUpperCase().equals(option_rarea)) 
						            {
						                searchResult2.add(searchResult.get(i));
						            }
						        }
							}
							searchResult=searchResult2;
						}
					}
					
					else if(search_option==4)
					{
						if(searchResult.size()==0)
						{
							System.out.print("\nNao foi possivel encontrar nenhum investigador/artigo com a sua pesquisa.");
							System.out.print("\nTente Novamente...");
						}
						
						else if(searchResult.size()>0)
						{
							search_on = false;
							
							// Criar um novo catalogo com os resultados da pesquisa
						    Catalog Results_Catalog = new Catalog();
						    Results_Catalog.getResearchers().addAll(searchResult);
						    
						    // Criar novo ficheiro XML com os dados filtrados
						    File search_results = new File("input_filter.xml");
						    
						    // Escrever novo XML filtrado 
						    try 
						    {
						      // Criar Marshaller
						      Marshaller jaxb_marshaller = jaxbContext.createMarshaller();
						      jaxb_marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true); 

						      // Escrever o ficheiro, usando Marshal
						      jaxb_marshaller.marshal(Results_Catalog, search_results);
						      System.out.print("\n\nO novo documento XML filtrado com a sua pesquisa foi gerado com sucesso!");
						    } 
						    catch (JAXBException e) 
						    {
						      e.printStackTrace();
						      System.out.println("Nao foi possivel gerar o novo documento XML filtrado com a sua pesquisa...");
						    }
						}
						
					}
			    } 
		    }
		}
		scan.close();
	}
}