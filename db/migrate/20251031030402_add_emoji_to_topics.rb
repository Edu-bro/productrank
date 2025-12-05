class AddEmojiToTopics < ActiveRecord::Migration[8.0]
  def change
    add_column :topics, :emoji, :string

    # 기존 토픽에 이모지 추가
    reversible do |dir|
      dir.up do
        emoji_mapping = {
          'ai' => '🤖',
          'productivity' => '📝',
          'design' => '🎨',
          'development' => '💻',
          'health' => '💪',
          'finance' => '💰',
          'education' => '🎓',
          'ecommerce' => '🛒'
        }

        emoji_mapping.each do |slug, emoji|
          execute "UPDATE topics SET emoji = '#{emoji}' WHERE slug = '#{slug}'"
        end
      end
    end
  end
end
