defmodule Aicacia.Id.Web.View.ErrorHelpers do
  use Phoenix.HTML

  def error_tag(form, field) do
    form.errors
    |> Keyword.get_values(field)
    |> Enum.map(fn error ->
      content_tag(:span, translate_error(error),
        class: "invalid-feedback",
        phx_feedback_for: input_id(form, field)
      )
    end)
  end

  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(Aicacia.Id.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(Aicacia.Id.Gettext, "errors", msg, opts)
    end
  end
end
