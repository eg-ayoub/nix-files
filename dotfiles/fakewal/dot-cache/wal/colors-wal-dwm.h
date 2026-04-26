static const char norm_fg[] = "#f9f8f5";
static const char norm_bg[] = "#272822";
static const char norm_border[] = "#75715e";

static const char sel_fg[] = "#f9f8f5";
static const char sel_bg[] = "#f92672";
static const char sel_border[] = "#f9f8f5";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
};
