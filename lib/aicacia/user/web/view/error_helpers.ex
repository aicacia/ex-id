defmodule Aicacia.User.Web.View.ErrorHelpers do
  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(Aicacia.User.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(Aicacia.User.Gettext, "errors", msg, opts)
    end
  end
end
