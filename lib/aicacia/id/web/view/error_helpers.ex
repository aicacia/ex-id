defmodule Aicacia.Id.Web.View.ErrorHelpers do
  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(Aicacia.Id.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(Aicacia.Id.Gettext, "errors", msg, opts)
    end
  end
end
