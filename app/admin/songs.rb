ActiveAdmin.register Song do
  permit_params :title, :content, :position

  show do
    attributes_table do
      row :position
      row :title
      row :content do |song|
        simple_format song.content
      end
      row :created_at
      row :updated_at

      active_admin_comments
    end
  end

end
