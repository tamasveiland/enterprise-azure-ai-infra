from dotenv import load_dotenv
from azure.identity import DefaultAzureCredential
from azure.core.credentials import AzureKeyCredential
import os

from azure.search.documents.indexes import SearchIndexerClient
from azure.search.documents.indexes.models import SearchIndexerDataContainer, SearchIndexerDataSourceConnection
from azure.search.documents.indexes._generated.models import NativeBlobSoftDeleteDeletionDetectionPolicy

from azure.search.documents.indexes.models import (
    SplitSkill,
    InputFieldMappingEntry,
    OutputFieldMappingEntry,
    AzureOpenAIEmbeddingSkill,
    SearchIndexerIndexProjections,
    SearchIndexerIndexProjectionSelector,
    SearchIndexerIndexProjectionsParameters,
    IndexProjectionMode,
    SearchIndexerSkillset
)

from azure.search.documents.indexes.models import (
    SearchIndexer,
    FieldMapping
)

# Load environment variables
load_dotenv(override=True)
endpoint = os.environ["AZURE_SEARCH_SERVICE_ENDPOINT"]
credential = DefaultAzureCredential()
blob_container_name = "rag"
blob_connection_string = f"ResourceId={os.environ["BLOB_RESOURCE_ID"]};" 
azure_openai_endpoint = os.environ["AZURE_OPENAI_ENDPOINT"]
azure_openai_key = os.environ["AZURE_OPENAI_KEY"]
azure_openai_embedding_deployment = "text-embedding-ada-002"
index_name = "vegetables"

# Create a data source 
indexer_client = SearchIndexerClient(endpoint, credential)
container = SearchIndexerDataContainer(name=blob_container_name)
data_source_connection = SearchIndexerDataSourceConnection(
    name="vegetables",
    type="azureblob",
    connection_string=blob_connection_string,
    container=container,
    data_deletion_detection_policy=NativeBlobSoftDeleteDeletionDetectionPolicy(),
    data_to_extract="storageMetadata"
)
data_source = indexer_client.create_or_update_data_source_connection(data_source_connection)

print(f"Data source '{data_source.name}' created or updated")

from azure.search.documents.indexes import SearchIndexClient
from azure.search.documents.indexes.models import (
    SearchField,
    SearchFieldDataType,
    VectorSearch,
    HnswAlgorithmConfiguration,
    HnswParameters,
    VectorSearchAlgorithmMetric,
    ExhaustiveKnnAlgorithmConfiguration,
    ExhaustiveKnnParameters,
    VectorSearchProfile,
    AzureOpenAIVectorizer,
    AzureOpenAIParameters,
    SemanticConfiguration,
    SemanticSearch,
    SemanticPrioritizedFields,
    SemanticField,
    SearchIndex
)

# Create a search index  
index_client = SearchIndexClient(endpoint=endpoint, credential=credential)  
fields = [  
    SearchField(name="parent_id", type=SearchFieldDataType.String, sortable=True, filterable=True, facetable=True),  
    SearchField(name="title", type=SearchFieldDataType.String),  
    SearchField(name="chunk_id", type=SearchFieldDataType.String, key=True, sortable=True, filterable=True, facetable=True, analyzer_name="keyword"),  
    SearchField(name="chunk", type=SearchFieldDataType.String, sortable=False, filterable=False, facetable=False),  
    SearchField(name="vector", type=SearchFieldDataType.Collection(SearchFieldDataType.Single), vector_search_dimensions=1536, vector_search_profile_name="myHnswProfile"),  
]  
  
# Configure the vector search configuration  
vector_search = VectorSearch(  
    algorithms=[  
        HnswAlgorithmConfiguration(  
            name="myHnsw",  
            parameters=HnswParameters(  
                m=4,  
                ef_construction=400,  
                ef_search=500,  
                metric=VectorSearchAlgorithmMetric.COSINE,  
            ),  
        ),  
        ExhaustiveKnnAlgorithmConfiguration(  
            name="myExhaustiveKnn",  
            parameters=ExhaustiveKnnParameters(  
                metric=VectorSearchAlgorithmMetric.COSINE,  
            ),  
        ),  
    ],  
    profiles=[  
        VectorSearchProfile(  
            name="myHnswProfile",  
            algorithm_configuration_name="myHnsw",  
            vectorizer="myOpenAI",  
        ),  
        VectorSearchProfile(  
            name="myExhaustiveKnnProfile",  
            algorithm_configuration_name="myExhaustiveKnn",  
            vectorizer="myOpenAI",  
        ),  
    ],  
    vectorizers=[  
        AzureOpenAIVectorizer(  
            name="myOpenAI",  
            kind="azureOpenAI",  
            azure_open_ai_parameters=AzureOpenAIParameters(  
                resource_uri=azure_openai_endpoint,  
                deployment_id=azure_openai_embedding_deployment,  
                api_key=azure_openai_key,  
            ),  
        ),  
    ],  
)  
  
semantic_config = SemanticConfiguration(  
    name="my-semantic-config",  
    prioritized_fields=SemanticPrioritizedFields(  
        content_fields=[SemanticField(field_name="chunk")]  
    ),  
)  
  
# Create the semantic search with the configuration  
semantic_search = SemanticSearch(configurations=[semantic_config])  
  
# Create the search index
index = SearchIndex(name=index_name, fields=fields, vector_search=vector_search, semantic_search=semantic_search)  
result = index_client.create_or_update_index(index)  
print(f"{result.name} created")  

# Create a skillset  
skillset_name = f"{index_name}-skillset"  
  
split_skill = SplitSkill(  
    description="Split skill to chunk documents",  
    text_split_mode="pages",  
    context="/document",  
    maximum_page_length=2000,  
    page_overlap_length=500,  
    inputs=[  
        InputFieldMappingEntry(name="text", source="/document/content"),  
    ],  
    outputs=[  
        OutputFieldMappingEntry(name="textItems", target_name="pages")  
    ],  
)  
  
embedding_skill = AzureOpenAIEmbeddingSkill(  
    description="Skill to generate embeddings via Azure OpenAI",  
    context="/document/pages/*",  
    resource_uri=azure_openai_endpoint,  
    deployment_id=azure_openai_embedding_deployment,  
    api_key=azure_openai_key,  
    inputs=[  
        InputFieldMappingEntry(name="text", source="/document/pages/*"),  
    ],  
    outputs=[  
        OutputFieldMappingEntry(name="embedding", target_name="vector")  
    ],  
)  
  
index_projections = SearchIndexerIndexProjections(  
    selectors=[  
        SearchIndexerIndexProjectionSelector(  
            target_index_name=index_name,  
            parent_key_field_name="parent_id",  
            source_context="/document/pages/*",  
            mappings=[  
                InputFieldMappingEntry(name="chunk", source="/document/pages/*"),  
                InputFieldMappingEntry(name="vector", source="/document/pages/*/vector"),  
                InputFieldMappingEntry(name="title", source="/document/metadata_storage_name"),  
            ],  
        ),  
    ],  
    parameters=SearchIndexerIndexProjectionsParameters(  
        projection_mode=IndexProjectionMode.SKIP_INDEXING_PARENT_DOCUMENTS  
    ),  
)  
  
skillset = SearchIndexerSkillset(  
    name=skillset_name,  
    description="Skillset to chunk documents and generating embeddings",  
    skills=[split_skill, embedding_skill],  
    index_projections=index_projections,  
)  
  
client = SearchIndexerClient(endpoint, credential)  
client.create_or_update_skillset(skillset)  
print(f"{skillset.name} created")  

# Create an indexer  
indexer_name = f"{index_name}-indexer"  
  
indexer = SearchIndexer(  
    name=indexer_name,  
    description="Indexer to index documents and generate embeddings",  
    skillset_name=skillset_name,  
    target_index_name=index_name,  
    data_source_name=data_source.name,  
    # Map the metadata_storage_name field to the title field in the index to display the PDF title in the search results  
    field_mappings=[FieldMapping(source_field_name="metadata_storage_name", target_field_name="title")]  
)  
  
indexer_client = SearchIndexerClient(endpoint, credential)  
indexer_result = indexer_client.create_or_update_indexer(indexer)  
  
# Run the indexer  
indexer_client.run_indexer(indexer_name)  
print(f' {indexer_name} is created and running. If queries return no results, please wait a bit and try again.')  