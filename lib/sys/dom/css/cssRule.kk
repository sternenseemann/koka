public module sys/dom/css/cssRule

// Interface CSSRule (generated by esidl 0.2.0).

import sys/dom/types

/* safe and unsafe conversion from all types including `any */
external inline maybeCssRule  : forall<a> (a) -> maybe<cssRule>
{ inline "(#1.toString()==='[object CSSRule]'?std_core.Just(#1):std_core.Nothing)" }
external inline toCssRule : forall<a> (a) -> exn cssRule
{ inline "(#1.toString()==='[object CSSRule]'?#1:std_core.error('toCssRule: cast failed'))" }


// CSSRule implements CSSRule (supplemental)
external inline type_ : (this: cssRule) -> dom cssRuleType
{ inline "#1.type" }
external inline cssText : (this: cssRule) -> dom string
{ inline "#1.cssText" }
external inline cssText : (this: cssRule, assigned: string) -> dom ()
{ inline "(#1.cssText = #2)" }
external inline parentRule : (this: cssRule) -> dom cssRule
{ inline "#1.parentRule" }
external inline parentStyleSheet : (this: cssRule) -> dom cssStyleSheet
{ inline "#1.parentStyleSheet" }
