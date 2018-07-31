RSpec.describe Telegram::Bot::Types::Update do
  subject { instance }
  let(:instance) { described_class.new(attrs) }
  let(:from) { { id: 1, is_bot: false, first_name: 'Test' } }
  let(:inline_query) { { id: 1, from: from, query: 'Test', offset: 'Test' } }
  let(:chosen_inline_result) { { result_id: 1, from: from, query: 'Test' } }
  let(:chat) { { id: 1, type: 'channel' } }
  let(:message) { { message_id: 1, date: 1533055307, chat: chat } }
  let(:attrs) do
    {
      update_id: 1,
      message: message,
      inline_query: inline_query,
      chosen_inline_result: chosen_inline_result,
    }
  end

  {
    'message' => 'Message',
    'inline_query' => 'InlineQuery',
    'chosen_inline_result' => 'ChosenInlineResult',
  }.each do |field, klass|
    field_class = Telegram::Bot::Types.const_get(klass)
    its(field) { should be_instance_of field_class }
    its([field]) { should be_instance_of field_class }
  end
end
