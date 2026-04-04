-- terrain_codes.lua — Complete reference of available terrain codes
-- This file is for reference only, not loaded by the game.

-- WATER
-- Wog = Gray Deep Water, Wo = Medium Deep Water, Wot = Tropical Deep Water
-- Wwg = Gray Shallow Water, Ww = Medium Shallow Water, Wwt = Tropical Shallow Water
-- Wwf = Ford, Wwr = Coastal Reef, Ss = Swamp Water Reed, Sm = Muddy Quagmire

-- FLAT/GRASS
-- Gg = Green Grass, Gs = Semi-dry Grass, Gd = Dry Grass, Gll = Leaf Litter
-- Rb = Dark Dirt, Re = Regular Dirt, Rd = Dry Dirt
-- Rr = Regular Cobbles, Rrc = Clean Gray Cobbles, Rrd = Rocky Sands
-- Rp = Overgrown Cobbles, Rra = Icy Cobbles

-- FROZEN
-- Ai = Ice, Aa = Snow

-- DESERT
-- Dd = Desert Sands, Ds = Beach Sands
-- ^Do = Oasis overlay, ^Dr = Rubble overlay, ^Dc = Crater overlay

-- EMBELLISHMENTS (overlays)
-- ^Efm = Mixed Flowers, ^Gvs = Farmland, ^Es = Stones, ^Esa = Snowbits
-- ^Em = Small Mushrooms, ^Emf = Mushroom Farm, ^Edp = Desert Plants (with bones)
-- ^Edpp = Desert Plants (no bones), ^Wm = Windmill, ^Ecf = Campfire
-- ^Efs = Sconce, ^Eb = Brazier, ^Ebn = Lit Brazier, ^Eff = Fence
-- ^Eqf = Iron Fence, ^Eqp = Wooden Palisade, ^Esd = Stones with Sand Drifts
-- ^Ewl = Water Lilies, ^Ewf = Flowering Water Lilies, ^Ewsh = Seashells
-- ^Edt = Trash, ^Edb = Remains, ^Exw = Window

-- FOREST (overlays)
-- ^Fet = Great Tree, ^Feta = Snowy Great Tree, ^Fetd = Dead Great Tree
-- ^Feth = Dead Great Oak, ^Ft = Tropical Forest, ^Ftr = Rainforest
-- ^Ftd = Palm Forest, ^Ftp = Dense Palm Forest, ^Fts = Savanna
-- ^Fp = Pine Forest, ^Fpa = Snowy Pine Forest
-- ^Fds = Summer Deciduous, ^Fdf = Fall Deciduous, ^Fdw = Winter Deciduous, ^Fda = Snowy Deciduous
-- ^Fms = Summer Mixed, ^Fmf = Fall Mixed, ^Fmw = Winter Mixed, ^Fma = Snowy Mixed

-- HILLS
-- Hh = Regular Hills, Hhd = Dry Hills, Hd = Dunes, Ha = Snow Hills

-- MOUNTAINS
-- Mm = Regular Mountains, Md = Dry Mountains, Ms = Snowy Mountains, Mdd = Desert Mountains
-- Mv = Volcano, Mm^Xm = Impassable Mountains, Md^Xm = Dry Impassable, Ms^Xm = Snowy Impassable

-- INTERIOR
-- Isr = Basic Stone Floor, Isa = Ancient Stone Floor, Isc = Royal Rug
-- Iwr = Basic Wooden Floor, Iwo = Old Wooden Floor
-- ^Ii = Beam of Light

-- CAVE
-- Uu = Cave Floor, Uue = Earthy Cave Floor, Urb = Dark Flagstones, Ur = Cave Path
-- Tb = Mycelium, ^Tf = Mushroom Grove, ^Tfi = Lit Mushroom Grove
-- Uh = Rockbound Cave, Uhe = Earthy Rockbound Cave
-- ^Br| ^Br/ ^Br\ = Mine Rails

-- CHASMS/LAVA
-- Qxu = Regular Chasm, Qxe = Earthy Chasm, Qxua = Ethereal Abyss
-- Ql = Lava Chasm, Qlf = Lava

-- WALLS (impassable)
-- Xu = Natural Cave Wall, Xuc = Mine Wall, Xue = Earthy Cave Wall, Xur = Damaged Cave Wall
-- Xuf = Hedges Wall, Xos = Stone Wall, Xom = Straight Mine Wall
-- Xoi = White Wall, Xoc = Clean Stone Wall, Xoa = Ancient Stone Wall
-- Xot = Catacombs Wall, Xof = Overgrown Stone Wall, Xor = Damaged Stone Wall
-- Exos = Ruined Wall (walkable!)

-- GATES/DOORS
-- ^Pr| ^Pr/ ^Pr\ = Rusty Gate (impassable)
-- ^Pw| ^Pw/ ^Pw\ = Wooden Door (impassable)
-- ^Pr|o ^Pr/o ^Pr\o = Open Rusty Gate (walkable)
-- ^Pw|o ^Pw/o ^Pw\o = Open Wooden Door (walkable)

-- VILLAGES (overlays)
-- ^Vda = Adobe, ^Vdr = Ruined Adobe, ^Vdt = Desert Tent, ^Vct = Tent
-- ^Vo = Orcish, ^Voa = Snowy Orcish, ^Vea = Snowy Elven, ^Ve = Elven
-- ^Vh = Cottage, ^Vha = Snowy Cottage, ^Vhr = Ruined Cottage
-- ^Vhc = Human City, ^Vwm = Windmill Village, ^Vhca = Snowy Human City, ^Vhcr = Ruined Human City
-- ^Vhh = Hill Stone Village, ^Vhha = Snowy Hill Stone, ^Vhhr = Ruined Hill Stone
-- ^Vht = Tropical Village, ^Vd = Drake Village, ^Vka = Snowy Drake
-- ^Vu = Cave Village, ^Vud = Dwarven Village
-- ^Vc = Hut, ^Vca = Snowy Hut, ^Vl = Log Cabin, ^Vla = Snowy Log Cabin
-- ^Vaa = Igloo, ^Vhs = Swamp Village, ^Vm = Merfolk Village

-- CASTLES
-- Ce = Encampment, Cer = Ruined Encampment, Cea = Snowy Encampment
-- Co = Orcish Castle, Coa = Snowy Orcish, Ch = Human Castle, Cha = Snowy Human
-- Cv = Elven Castle, Cvr = Elven Ruin, Cva = Winter Elven
-- Cud = Dwarven Underground, Cf = Dwarven Castle, Cfr = Dwarven Ruins, Cfa = Winter Dwarven
-- Chr = Ruined Human Castle, Chw = Sunken Ruin, Chs = Swamp Ruin
-- Cd = Desert Castle, Cdr = Ruined Desert, Cte = Troll Encampment
-- Cme = Aquatic Encampment, Cm = Aquatic Castle

-- KEEPS
-- Ke = Encampment Keep, Ker = Ruined Keep, Ket = Tall Keep, Kea = Snowy Keep
-- Ko = Orcish Keep, Koa = Snowy Orcish, Kh = Human Castle Keep, Kha = Snowy Human
-- Kv = Elven Keep, Kvr = Elven Ruin Keep, Kva = Winter Elven
-- Kud = Dwarven Underground Keep, Kf = Dwarven Keep, Kfr = Dwarven Ruin Keep, Kfa = Winter Dwarven
-- Khr = Ruined Human Keep, Khw = Sunken Keep, Khs = Swamp Keep
-- Kd = Desert Keep, Kdr = Ruined Desert Keep
-- Kme = Aquatic Encampment Keep, Kte = Troll Keep, Km = Aquatic Keep

-- BRIDGES (overlays)
-- ^Bw| ^Bw/ ^Bw\ = Wooden Bridge (N-S, NE-SW, SE-NW)
-- ^Bw|r ^Bw/r ^Bw\r = Rotting Bridge
-- ^Bsb| ^Bsb/ ^Bsb\ = Basic Stone Bridge
-- ^Bsa| ^Bsa/ ^Bsa\ = Snowy Stone Bridge
-- ^Bs| ^Bs/ ^Bs\ = Cave Chasm Bridge
-- ^Bh| ^Bh/ ^Bh\ = Hanging Bridge
-- ^Bcx| ^Bcx/ ^Bcx\ = Stone Chasm Bridge
-- ^Bp| ^Bp/ ^Bp\ = Plank Bridge
