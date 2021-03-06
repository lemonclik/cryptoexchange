require 'spec_helper'

RSpec.describe 'Dextop integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:snt_eth_pair) { Cryptoexchange::Models::MarketPair.new(base: 'SNT', target: 'ETH', market: 'dextop') }

  it 'fetch pairs' do
    pairs = client.pairs('dextop')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'dextop'
  end

  it 'fetch ticker' do
    ticker = client.ticker(snt_eth_pair)

    expect(ticker.base).to eq 'SNT'
    expect(ticker.target).to eq 'ETH'
    expect(ticker.market).to eq 'dextop'
    expect(ticker.last).to be_a Numeric
    expect(ticker.low).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.change).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.volume).to be > 0.0
    expect(ticker.timestamp).to be nil
    
    expect(ticker.payload).to_not be nil
  end

  it 'fetch order book' do
    order_book = client.order_book(snt_eth_pair)

    expect(order_book.base).to eq 'SNT'
    expect(order_book.target).to eq 'ETH'
    expect(order_book.market).to eq 'dextop'
    expect(order_book.asks).to_not be_empty
    expect(order_book.bids).to_not be_empty
    expect(order_book.asks.first.price).to_not be_nil
    expect(order_book.bids.first.amount).to_not be_nil
    expect(order_book.bids.first.timestamp).to be_nil
    expect(order_book.asks.count).to be > 1
    expect(order_book.bids.count).to be > 1
    expect(order_book.payload).to_not be nil
  end

  it 'fetch trade' do
    trades = client.trades(snt_eth_pair)
    trade = trades.sample

    expect(trades).to_not be_empty
    expect(trade.base).to eq 'SNT'
    expect(trade.target).to eq 'ETH'
    expect(trade.market).to eq 'dextop'
    expect(['buy', 'sell']).to include trade.type
    expect(trade.price).to_not be_nil
    expect(trade.amount).to_not be_nil
    expect(trade.timestamp).to be_a Numeric
    expect(trade.payload).to_not be nil
  end
end
