require 'rails_helper'

RSpec.shared_examples 'Searchable' do
  before(:each) do
    allow(described_class).to receive(:where) { described_class }
    allow(described_class).to receive(:order) { described_class }
  end

  it 'generates the correct where clause for the query' do
    where_clause = "search_vector @@ plainto_tsquery('english', 'chicken soup')"

    described_class.search('chicken soup')

    expect(described_class).to have_received(:where).with(where_clause)
  end

  it 'generates the correct order clause for the query' do
    order_clause = "ts_rank_cd(search_vector, plainto_tsquery('english', 'chicken soup')) DESC"

    described_class.search('chicken soup')

    expect(described_class).to have_received(:order).with(order_clause)
  end
end
