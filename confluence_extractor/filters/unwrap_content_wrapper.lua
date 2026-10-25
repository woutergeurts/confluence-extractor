-- Remove Confluence's presentational wrapper from the Pandoc document.
-- Keeping the contents makes the resulting Markdown portable to editors
-- that do not support Pandoc fenced divs, such as Visual Studio.
function Div(el)
  for _, class in ipairs(el.classes) do
    if class == "content-wrapper" then
      return el.content
    end
  end

  return el
end
