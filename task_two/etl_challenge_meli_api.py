from requests_futures.sessions import FuturesSession
from concurrent.futures import as_completed
import pandas as pd
import requests
from pandas import json_normalize, DataFrame

class MercadoLibreAuthenticator:
    """Class used to make the request access token Mercado Libre call."""

    def __init__(self, grant_type, client_id, client_secret):
        """Mercado Libre Authenticator constructor.

        Args:
            grant_type (str): authorization_code – it shows that the desired operation is to
            exchange the “code” for an access token.

            client_id (str): is the APP ID of the application that you created.

            client_secret (str): Secret Key generated when the app was created.
        """

        self.__grant_type = grant_type
        self.__client_id = client_id
        self.__client_secret = client_secret

    def get_auth_token(self):
        """Make the request and return the authorization token.

        Raises:
            HTTPError: When response contains error HTTP status codes.

        Returns:
            response.text (str): Authorization token for Mercado Libre API.
        """
        body = {
            "grant_type": self.__grant_type,
            "client_id": self.__client_id,
            "client_secret": self.__client_secret
        }
        response = requests.post(
            url='https://api.mercadolibre.com/oauth/token',
            json=body
        )
        if response.status_code >= 200 and response.status_code < 300:
            return response.json()["access_token"]
        response.raise_for_status()
        return None

class MercadoLibreItems:
    """Class used to make the request Mercado Libre API call."""

    def __init__(self, access_token):
        """Mercado Libre constructor.

        Args:
            access_token (srt): Authorization Bearer token.
        """
        self.__token = access_token.replace('"', '')

    def get_items(self, item_id):
        """Get the response for Mercado Libre API based on item_id.

        Args:
            item_id (str): Item code to be sent.

        Raises:
            HTTPError: When response contains error HTTP status codes.

        Returns:
            json (obj): Data from Mercado Libre API.

        """
        headers = {"Authorization": "Bearer " + self.__token}
        response = requests.get(
            url='https://api.mercadolibre.com/items/{0}'.format(item_id),
            headers=headers
        )
        if response.status_code >= 200 and response.status_code < 300:
            return response.json()
        response.raise_for_status()
        return None

class MercadoLibreProducts(object):
    def __init__(self):
        self.products = ['Google Home', 'Apple TV','Amazon Fire TV', 'Nvidia Shield TV', 'Nokia TV']
        self.api_url = 'https://api.mercadolibre.com/sites/MLA'

    def request_pages(self, first_page):
        first_response = requests.get(first_page).json()

        # list to store all the pages responses
        page_responses = [first_response]

        next_page = first_response.get('paging', {}).get('next')

        while next_page:
            page_response = requests.get(next_page).json()

            if 'data' in page_response and page_response['data']:
                page_responses.append(page_response)
            else:
                break

            next_page = page_response.get('paging', {}).get('next')

        return page_responses

    def get_all_posts(self):
        # create a generic request for retrieving all the post from a given product name

        all_posts_generic_req = f"{self.api_url}/search?q={{product}}&limit=50#json"

        # for each product name, create its own request, replacing black spaces with %20
        all_posts_requests = [
        all_posts_generic_req.format(product=product.replace(" ", "%20")) for product in self.products
        ]

        posts_data = []

        with FuturesSession() as session:
            # make all the requests in parallel
            futures = [session.get(req) for req in all_posts_requests]

            for future in as_completed(futures):
                response = future.result().json()

                df_subcategories = json_normalize(response)

                expanded_data = []

                for row in df_subcategories.itertuples(index=False):
                    for child_cat in row.results:
                        expanded_data.append({
                            'site_id': row.site_id,
                            'country_default_time_zone': row.country_default_time_zone,
                            'query': row.query,
                            'id': child_cat['id'],
                            'title': child_cat['title'],
                            'condition': child_cat['condition'],
                            'thumbnail_id': child_cat['thumbnail_id'],
                            'catalog_product_id': child_cat['catalog_product_id'],
                            'listing_type_id': child_cat['listing_type_id'],
                            'permalink': child_cat['permalink'],
                            'site_id': child_cat['site_id'],
                            'category_id': child_cat['category_id'],
                            'domain_id': child_cat['domain_id'],
                            'thumbnail': child_cat['thumbnail'],
                            'currency_id': child_cat['currency_id'],
                            'price': child_cat['price'],
                            'original_price': child_cat['original_price'],
                            'sale_price': child_cat['sale_price'],
                            'sold_quantity': child_cat['sold_quantity'],
                            'available_quantity': child_cat['available_quantity']

                        })
                expanded_df = pd.DataFrame(expanded_data)
                posts_data.append(expanded_df)
            posts_data = pd.concat(posts_data)

        return posts_data

if __name__ == "__main__":
    auth = MercadoLibreAuthenticator('private', 'private', 'private')
    token = auth.get_auth_token()
    mercado_libre_process = MercadoLibreProducts()
    posts_df = mercado_libre_process.get_all_posts()
    df_items_id = pd.DataFrame()
    df_items_id['id'] = posts_df['id']
    mercado_libre_items = MercadoLibreItems(token)
    df_items = []
    item_df = pd.DataFrame()
    for item in df_items_id['id']:
        req_item = mercado_libre_items.get_items(item)
        item_df = json_normalize(req_item)
        df_items.append(item_df)
    df_items = pd.concat(df_items)
    # Delete duplicated
    df_items.drop(columns=['sold_quantity',
                           'thumbnail_id',
                           'site_id',
                           'permalink',
                           'thumbnail',
                           'price',
                           'condition',
                           'available_quantity',
                           'currency_id',
                           'title',
                           'original_price',
                           'catalog_product_id',
                           'listing_type_id',
                           'domain_id',
                           'category_id'], inplace=True)

    merged_df = pd.merge(posts_df,df_items,on= ['id'],how='inner')
    #Save to JSON
    merged_df.to_json('mercado_libre_api_result.json', orient='records')