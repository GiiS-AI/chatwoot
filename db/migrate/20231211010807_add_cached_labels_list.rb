class AddCachedLabelsList < ActiveRecord::Migration[7.0]
  def change
    add_column :conversations, :cached_label_list, :string
    Conversation.reset_column_information
    # GiiS-AI patch: ActsAsTaggableOn::Taggable::Cache.included is unavailable in
    # acts-as-taggable-on v10.x (the constant was removed). Backfill the cache column
    # manually using the existing taggings table instead.
    execute <<~SQL
      UPDATE conversations c
      SET cached_label_list = sub.labels
      FROM (
        SELECT taggable_id,
               string_agg(tags.name, ', ' ORDER BY tags.name) AS labels
        FROM taggings
        JOIN tags ON tags.id = taggings.tag_id
        WHERE taggable_type = 'Conversation'
          AND taggings.context = 'labels'
        GROUP BY taggable_id
      ) sub
      WHERE c.id = sub.taggable_id
    SQL
  end
end
