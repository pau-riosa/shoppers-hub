defmodule PaymongoExample.Photo do
  @moduledoc """
  photo uploader
  """
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original, :thumb]

  def __storage, do: Arc.Storage.Local

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png)
    |> Enum.member?(Path.extname(String.downcase(file.file_name)))
  end

  # Define a transformation:
  def transform(:original, _), do: :noaction

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
  end

  # Override the persisted filenames:
  def filename(_version, {file, _}) do
    Path.rootname(file.file_name)
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, scope}) do
    "uploads/item/#{scope.id}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: MIME.from_path(file.file_name)]
  # end
end
