function translate (es,en, pt) {
    local Lang = ::UI.getData ("Language");
    if (Lang == "Espanol") Console.Print (es);
    else if (Lang == "Portuguese") Console.Print (pt);
    else Console.Print (en);
}