public module sys/dom/css/elementCssInlineStyle

// Interface ElementCSSInlineStyle (generated by esidl 0.2.0).

import sys/dom/types

/* safe and unsafe conversion from all types including `any */
external inline maybeElementCssInlineStyle  : forall<a> (a) -> maybe<elementCssInlineStyle>
{ inline "(#1.toString()==='[object ElementCSSInlineStyle]'?std_core.Just(#1):std_core.Nothing)" }
external inline toElementCssInlineStyle : forall<a> (a) -> exn elementCssInlineStyle
{ inline "(#1.toString()==='[object ElementCSSInlineStyle]'?#1:std_core.error('toElementCssInlineStyle: cast failed'))" }


// ElementCSSInlineStyle implements ElementCSSInlineStyle (supplemental)
external inline style : (this: elementCssInlineStyle) -> dom cssStyleDeclaration
{ inline "#1.style" }
