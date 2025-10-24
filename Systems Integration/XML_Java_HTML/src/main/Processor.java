package main;

import java.io.File;
import java.io.IOException;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Scanner;

import org.xml.sax.SAXException;

import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.JAXBException;
import jakarta.xml.bind.Marshaller;
import jakarta.xml.bind.Unmarshaller;

import generated.Catalog;
import generated.Statistics;

public class Processor
{
	public static void main(String[] args) throws SAXException
	{
		Scanner scanner = new Scanner(System.in);

		// importar o ficheiro input_filer.xml vindo do Selector
		File xmlFile = new File("input_filter.xml");

		if (!xmlFile.exists())
		{
			System.out.println("O xml fornecido nao foi encontrado");
		}
		
		// validar xmlFile
		try
		{
			Selector.validate_xml("input_filter.xml","output.xsd");
			System.out.print("O ficheiro xml e valido!");
		}
		catch (IOException e)
		{
			System.out.print("O ficheiro xml e invalido!");
		}

		// leitura do ficheiro input_filter.xml vindo do Selector
		try
		{
			JAXBContext jaxbContext = JAXBContext.newInstance(Catalog.class);
			Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
			Catalog catalog = (Catalog) jaxbUnmarshaller.unmarshal(xmlFile);

			// estatisticas
			boolean search_on = true;
			Statistics estatisticas = new Statistics();
			List<String> titles = new ArrayList<>();

			while (search_on)
			{
				System.out.println("\n\n------------------- Estatisticas -------------------");
				System.out.println(" (Escolhe qual o tipo de estatistica que deseja saber) ");
				System.out.println("----------------------------------------------------");
				System.out.println("1) Numero de investigadores;");
				System.out.println("2) Numero de jornais/conferencias/sources/livros;");
				System.out.println("3) Numero de citacoes total;");
				System.out.println("4) Ranking de publicacoes com o maior numero de citacoes");
				System.out.println("5) Exportar as estatisticas (.xml)");
				boolean booleanC = true;
				int search_option = 0;
				while (booleanC)
				{
					System.out.print("\nOPCAO:");

					if (scanner.hasNextInt())
					{
						search_option = scanner.nextInt();

						if (search_option <= 5 && search_option > 0)
						{
							booleanC = false;
						}
						else
						{
							System.out.print("Opcao invalida. Escolha de 1) a 5)");
						}
						scanner.nextLine();
					}
					else
					{
						System.out.print("Opcao invalida. Escolha de 1) a 5)");
						scanner.nextLine();
					}
				}

				if (search_option == 1)
				{
					System.out.println("Foram encontrados " + catalog.getResearchers().size() + " investigadores!");
					estatisticas.setNumberResearchers(new BigInteger(String.valueOf(catalog.getResearchers().size())));
				}
				else if (search_option == 2)
				{
					List<String> conferences = new ArrayList<>();
					List<String> journals = new ArrayList<>();
					List<String> sources = new ArrayList<>();
					List<String> books = new ArrayList<>();
					for (int i = 0; i < catalog.getResearchers().size(); i++)
					{
						for( int j = 0; j < 7; j++)
						{
							String conference = catalog.getResearchers().get(i).getPublications().get(j).getPublicationSource().getConference();
							String journal = catalog.getResearchers().get(i).getPublications().get(j).getPublicationSource().getJournal();
							String source = catalog.getResearchers().get(i).getPublications().get(j).getPublicationSource().getSource();
							String book = catalog.getResearchers().get(i).getPublications().get(j).getPublicationSource().getBook();
							
							// Verificar e adicionar os valores as listas somente se eles nao forem null
							if (conference != null)
							{
								conferences.add(conference);
							}
							if (journal != null)
							{
								journals.add(journal);
							}
							if (source != null)
							{
								sources.add(source);
							}
							if (book != null)
							{
								books.add(book);
							}
						}
					}
					System.out.println("Foram encontradas: " + conferences.size() + " conferencias!");
					System.out.println("Foram encontrados: " + journals.size() + " jornais!");
					System.out.println("Foram encontrados: " + sources.size() + " sources!");
					System.out.println("Foram encontrados: " + books.size() + " livros!");
					estatisticas.setNumberConferences(new BigInteger(String.valueOf(conferences.size())));
					estatisticas.setNumberJournals(new BigInteger(String.valueOf(journals.size())));
					estatisticas.setNumberSources(new BigInteger(String.valueOf(sources.size())));
					estatisticas.setNumberBooks(new BigInteger(String.valueOf(books.size())));

				}

				else if (search_option == 3)
				{
					int somaCitations = 0;
					for (int i = 0; i < catalog.getResearchers().size(); i++)
					{
						for (int j = 0; j < 7; j++)
						{
							BigInteger citation = catalog.getResearchers().get(i).getPublications().get(j).getCitation();
							int citation_inteiro = citation.intValue();
							somaCitations += citation_inteiro;
						}
					}
					System.out.println("Foram obtidas no total " + somaCitations + " citacoes!");
					estatisticas.setNumberCitations(new BigInteger(String.valueOf(somaCitations)));

				}

				else if (search_option == 4)
				{
					boolean booleanD = true;
					int N = 0;
					while (booleanD)
					{
						System.out.print("\nQuantas publicacoes pretende que o ranking tenha? ");
						if (scanner.hasNextInt())
						{
							N = scanner.nextInt();

							if (N > 0)
							{
								booleanD = false;
							}
							else
							{
								System.out.print("Opcao invalida. Introduza um numero inteiro maior que 0");
							}
							scanner.nextLine();
						}
						else
						{
							System.out.print("Opcao invalida. Introduza um numero inteiro maior que 0");
							scanner.nextLine();
						}
					}

					List<Integer> citationList = new ArrayList<>();

					for (int i = 0; i < catalog.getResearchers().size(); i++)
					{
						for (int j = 0; j < 7; j++)
						{
							BigInteger citation = catalog.getResearchers().get(i).getPublications().get(j)
									.getCitation();
							int citation_inteiro = citation.intValue();
							citationList.add(citation_inteiro);
						}
					}

					// classificar citationList por ordem decrescente
					Comparator<Integer> comparadorReverso = Collections.reverseOrder();
					Collections.sort(citationList, comparadorReverso);

					System.out.println("");
					System.out.println("Top " + N + " publicacoes com mais citacoes:");
					System.out.println("");

					for (int k = 0; k < N && k < citationList.size(); k++)
					{
						int citation = citationList.get(k);
						for (int i = 0; i < catalog.getResearchers().size(); i++)
						{
							for (int j = 0; j < 7; j++)
							{
								if (catalog.getResearchers().get(i).getPublications().get(j).getCitation()
										.intValue() == citation)
								{
									String title = catalog.getResearchers().get(i).getPublications().get(j).getTitle();
									System.out.println("Numero de citacoes: " + citation + " - Titulo: " + title);
									titles.add(title);
									estatisticas.setTitle(titles);
								}
							}
						}
					}
				}
				else if (search_option == 5)
				{
					search_on = false;
					try
					{
						// criar catalogo para as estatisticas
						Catalog catalog_stats = new Catalog();
						catalog_stats.setStatistics(estatisticas);
						JAXBContext context = JAXBContext.newInstance(Catalog.class);
						// criacao do marshaller
						Marshaller marshaller = context.createMarshaller();
						marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);
						marshaller.marshal(catalog_stats, new File("statistics.xml"));
						Selector.validate_xml("statistics.xml","output_statistics.xsd");
						System.out.print("\n\nO novo documento XML com as estatisticas foi gerado com sucesso!");
					}
					catch (JAXBException e)
					{
						e.printStackTrace();
						System.out.print("\n\nO novo documento XML com as estatisticas nao foi gerado com sucesso!");
					}
					catch (IOException e)
					{
						System.out.print("O ficheiro xml e invalido!");
					}
				}
			}
		}
		catch (JAXBException e)
		{
			e.printStackTrace();
		}
		scanner.close();
	}
}
