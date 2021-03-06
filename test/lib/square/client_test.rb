require 'test_helper'
require 'square/client'

module Square
  class ClientTest < Minitest::Spec

    describe Square::Client do
      let(:api_key) { SecureRandom.base64 }
      let(:client)  { Square::Client.new(api_key: api_key) }

      describe '#list_customers' do
        let(:response_body) do
          { customers: [{ given_name: 'Shrike', family_name: 'Force' }] }.to_json
        end

        before do
          stub_request(:get, "https://connect.squareup.com/v2/customers").
            with(headers: {'Accept'=>'application/json', 'Authorization'=>"Bearer #{api_key}", 'Content-Type'=>'application/json', 'Expect'=>'', 'User-Agent'=>'Square-Connect-Ruby/2.0.2'}).
            to_return(status: 200, body: response_body, headers: {})
        end

        it 'lists the customers' do
          customers = client.list_customers.customers
          assert_equal(1, customers.count)
          customer = customers.first
          assert_equal('Shrike', customer.given_name)
          assert_equal('Force', customer.family_name)
        end
      end

      describe '#list_transactions' do
        let(:response_body) do
          { transactions: [{ id: SecureRandom.uuid }, {id: SecureRandom.uuid}] }.to_json
        end

        before do
          stub_request(:get, "https://connect.squareup.com/v2/locations/FZS7GXYFJ6HRB/transactions?sort_order=ASC").
            with(headers: {'Accept'=>'application/json', 'Authorization'=>"Bearer #{api_key}", 'Content-Type'=>'application/json', 'Expect'=>'', 'User-Agent'=>'Square-Connect-Ruby/2.0.2'}).
            to_return(status: 200, body: response_body, headers: {})
        end

        it 'lists the transactions' do
          transactions = client.list_transactions.transactions
          assert_equal(2, transactions.count)
        end
      end
    end
  end
end
