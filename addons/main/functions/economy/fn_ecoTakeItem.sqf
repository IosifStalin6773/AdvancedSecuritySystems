// [clase] (cliente que vende): retira una unidad del objeto vendido
params ["_c"];
switch (true) do {
    case (_c in (magazines player)): {player removeMagazine _c};
    case (_c in (items player)): {player removeItem _c};
    case (_c in (assignedItems player)): {player unassignItem _c; player removeItem _c};
    case (_c in (weapons player)): {player removeWeapon _c};
    case (_c isEqualTo backpack player): {removeBackpack player};
    case (_c isEqualTo vest player): {removeVest player};
    case (_c isEqualTo uniform player): {removeUniform player};
    case (_c isEqualTo headgear player): {removeHeadgear player};
    case (_c isEqualTo goggles player): {removeGoggles player};
};
