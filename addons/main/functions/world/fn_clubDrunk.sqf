// (cliente, 1.24) tres copas en el club: visión borrosa dos minutos
[] spawn {
    private _h = ppEffectCreate ["DynamicBlur", 450];
    _h ppEffectEnable true;
    _h ppEffectAdjust [1.2];
    _h ppEffectCommit 5;
    sleep 120;
    _h ppEffectAdjust [0];
    _h ppEffectCommit 10;
    sleep 10;
    ppEffectDestroy _h;
};
