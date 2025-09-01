ActiveAdmin.register Study do
  menu priority: 5

  permit_params :title, :content

  filter :title
  filter :content
  filter :created_at
  filter :updated_at

  form partial: 'form'

  show do
    attributes_table do
      row :title
      row :content do
        raw study.content
      end
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  index do
    selectable_column
    id_column
    column :title
    column :content do |study|
      div truncate(study.raw_content, length: 150), style: "max-width: 25rem"
    end
    column :created_at
    column :updated_at

    actions
  end

  action_item :view, only: [:show, :edit] do
    link_to 'View PDF', view_pdf_admin_study_path(study, format: :pdf), target: "_blank"
  end

  member_action :view_pdf, method: :get do
    @study = resource

    respond_to do |format|
      format.pdf do
        render pdf: @study.title,
               encoding: 'utf-8',
               layout: 'pdf',
               margin: {
                 top: 20,
                 left: 30,
                 right: 30
               },
               page_size: 'A4',
               lowquality: true,
               zoom: 1,
               dpi: 75
               #show_as_html: true
      end
    end
  end

end
