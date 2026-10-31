


--[[
    S.C.O.P.E. — SkillChain Opportunity Prediction Engine
    Created and maintained by Integrity / DPT

    SCOPE-specific additions, interface designs, and original enhancements
    contributed by Integrity / DPT are freely available to copy, edit,
    redistribute, improve, and reuse, including in other projects.
    No permission or credit is required for those original contributions.

    This permission applies only to material owned by Integrity / DPT.
    Any third-party code or assets retain their own applicable licenses
    and attribution requirements.
]]
_addon.author = 'Integrity/DPT'
_addon.commands = {'scope', 'sc'}
_addon.name = 'SCOPE'
_addon.version = '1.0.0'


texts = require('texts')
packets = require('packets')
config = require('config')
res = require('resources')

default = {
    ws=true,
    ma=true,
	hidews=true, -- only used to hide ws if main job == BST
    display = {
        text={size=8,font='Consolas'},
        pos={x=0,y=0},
        },
    }
  
settings = config.load(default)
skill_props = texts.new('',settings.display,settings)

lvl3 = S{'Darkness','Light'}
lvl4 = S{'Radiance','Umbra'}
radiance_ws = S{'Blade: Shun','Apex Arrow','Last Stand','Exenterator','Realmrazor','Resolution','Shijin Spiral','Tachi: Shoha','Upheaval'}
umbra_ws = S{'Shattersoul','Entropy','Requiescat','Ruinator','Stardiver'}
aeonic_weapons = S{'Heishi Shorinken','Godhands','Aeneas','Sequence','Lionheart','Tri-edge','Chango','Anguta','Trishula','Dojikiri Yasutsuna','Tishtrya','Khatvanga','Fail-Not','Fomalhaut'}

aftermath_props = T{
	['Blade: Shun'] = {skillchain_a="Light",skillchain_b="Fusion",skillchain_c="Impaction"}, 
	['Apex Arrow'] = {skillchain_a="Light",skillchain_b="Fragmentation",skillchain_c="Transfixion"}, 
	['Last Stand'] = {skillchain_a="Light",skillchain_b="Fusion",skillchain_c="Reverberation"}, 
	['Exenterator'] = {skillchain_a="Light",skillchain_b="Fragmentation",skillchain_c="Scission"}, 
	['Realmrazor'] = {skillchain_a="Light",skillchain_b="Fusion",skillchain_c="Impaction"}, 
	['Resolution'] = {skillchain_a="Light",skillchain_b="Fragmentation",skillchain_c="Scission"}, 
	['Shijin Spiral'] = {skillchain_a="Light",skillchain_b="Fusion",skillchain_c="Reverberation"}, 
	['Tachi: Shoha'] = {skillchain_a="Light",skillchain_b="Fragmentation",skillchain_c="Compression"}, 
	['Upheaval'] = {skillchain_a="Light",skillchain_b="Fusion",skillchain_c="Compression"}, 
	['Shattersoul'] = {skillchain_a="Darkness",skillchain_b="Gravitation",skillchain_c="Induration"}, 
	['Entropy'] = {skillchain_a="Darkness",skillchain_b="Gravitation",skillchain_c="Reverberation"}, 
	['Requiescat'] = {skillchain_a="Darkness",skillchain_b="Gravitation",skillchain_c="Scission"}, 
	['Ruinator'] = {skillchain_a="Darkness",skillchain_b="Distortion",skillchain_c="Detonation"}, 
	['Stardiver'] = {skillchain_a="Darkness",skillchain_b="Gravitation",skillchain_c="Transfixion"}, 
}

skillchains = L{
    [288] = 'Light',
    [289] = 'Darkness',
    [290] = 'Gravitation',
    [291] = 'Fragmentation',
    [292] = 'Distortion',
    [293] = 'Fusion',
    [294] = 'Compression',
    [295] = 'Liquefaction',
    [296] = 'Induration',
    [297] = 'Reverberation',
    [298] = 'Transfixion',
    [299] = 'Scission',
    [300] = 'Detonation',
    [301] = 'Impaction',
    [385] = 'Light',
    [386] = 'Darkness',
    [387] = 'Gravitation',
    [388] = 'Fragmentation',
    [389] = 'Distortion',
    [390] = 'Fusion',
    [391] = 'Compression',
    [392] = 'Liquefaction',
    [393] = 'Induration',
    [394] = 'Reverberation',
    [395] = 'Transfixion',
    [396] = 'Scission',
    [397] = 'Detonation',
    [398] = 'Impaction',
	[767] = 'Radiance',
    [768] = 'Umbra',
    [769] = 'Radiance',
    [770] = 'Umbra',
    }

colors = {
    ['Impaction'] = '\\cs(255,0,255)',
	['Lightning'] = '\\cs(255,0,255)',
	['Darkness'] = '\\cs(0,0,204)',
	['Umbra'] = '\\cs(0,0,204)',
    ['Gravitation'] = '\\cs(102,51,0)',
    ['Fragmentation'] = '\\cs(250,156,247)',
    ['Distortion'] = '\\cs(51,153,255)',
    ['Compression'] = '\\cs(0,0,204)',
	['Induration'] = '\\cs(0,255,255)',
	['Ice'] = '\\cs(0,255,255)',
    ['Reverberation'] = '\\cs(0,0,255)',
	['Water'] = '\\cs(0,0,255)',
    ['Transfixion'] = '\\cs(255,255,255)',
    ['Scission'] = '\\cs(153,76,0)',
	['Stone'] = '\\cs(153,76,0)',
	['Earth'] = '\\cs(153,76,0)',
    ['Detonation'] = '\\cs(102,255,102)',
	['Wind'] = '\\cs(102,255,102)',
    ['Fusion'] = '\\cs(255,102,102)',
    ['Liquefaction'] = '\\cs(255,0,0)',
	['Fire'] = '\\cs(255,0,0)',
}
    
elements = L{
    [0]={mb='Fire',sc='Liquefaction'},
    [1]={mb='Ice',sc='Induration'},
    [2]={mb='Wind',sc='Detonation'},
    [3]={mb='Earth',sc='Scission'},
    [4]={mb='Lightning',sc='Impaction'},
    [5]={mb='Water',sc='Reverberation'},
    [6]={mb='Light',sc='Transfixion'},
    [7]={mb='Darkness',sc='Compression'},
    }

prop_info = {
	Radiance = {elements='Fire Wind Lightning Light',properties={[1]={Light='Light'}},level=3},
	Umbra = {elements='Earth Ice Water Darkness',properties={[1]={Darkness='Darkness'}},level=3},
    Light = {elements='Fire Wind Lightning Light',properties={[1]={Light='Light'}},level=3},
    Darkness = {elements='Earth Ice Water Darkness',properties={[1]={Darkness='Darkness'}},level=3},
    Gravitation = {elements='Earth Darkness',properties={[1]={Distortion='Darkness'},[2]={Fragmentation='Fragmentation'}},level=2},
    Fragmentation = {elements='Wind Lightning',properties={[1]={Fusion='Light'},[2]={Distortion='Distortion'}},level=2},
    Distortion = {elements='Ice Water',properties={[1]={Gravitation='Darkness'},[2]={Fusion='Fusion'}},level=2},
    Fusion = {elements='Fire Light',properties={[1]={Fragmentation='Light'},[2]={Gravitation='Gravitation'}},level=2},
    Compression = {elements='Darkness',properties={[1]={Transfixion='Transfixion'},[2]={Detonation='Detonation'}},level=1},
    Liquefaction = {elements='Fire',properties={[1]={Impaction='Fusion'},[2]={Scission='Scission'}},level=1},
    Induration = {elements='Ice',properties={[1]={Reverberation='Fragmentation'},[2]={Compression='Compression'},[3]={Impaction='Impaction'}},level=1},
    Reverberation = {elements='Water',properties={[1]={Induration='Induration'},[2]={Impaction='Impaction'}},level=1},
    Transfixion = {elements='Light',properties={[1]={Scission='Distortion'},[2]={Reverberation='Reverberation'},[3]={Compression='Compression'}},level=1},
    Scission = {elements='Earth',properties={[1]={Liquefaction='Liquefaction'},[2]={Reverberation='Reverberation'},[3]={Detonation='Detonation'}},level=1},
    Detonation = {elements='Wind',properties={[1]={['Compression']='Gravitation'},[2]={['Scission']='Compression'}},level=1},
    Impaction = {elements='Lightning',properties={[1]={Liquefaction='Liquefaction'},[2]={Detonation='Detonation'}},level=1},
    }

blood_pacts = L{
    [513] = {id=513,avatar='Carbuncle',en='Poison Nails',skillchain_a='Transfixion'},
    [521] = {id=521,avatar='Cait Sith',en='Regal Scratch',skillchain_a='Scission'},
	[780] = {id=780,avatar='Cait Sith',en='Regal Gash',skillchain_a='Distortion',skillchain_b='Detonation'},
    [528] = {id=528,avatar='Fenrir',en='Moonlit Charge',skillchain_a='Compression'},
    [529] = {id=529,avatar='Fenrir',en='Crescent Fang',skillchain_a='Transfixion'},
    [534] = {id=534,avatar='Fenrir',en='Eclipse Bite',skillchain_a='Gravitation',skillchain_b='Scission'},
    [544] = {id=544,avatar='Ifrit',en='Punch',skillchain_a='Liquefaction'},
    [546] = {id=546,avatar='Ifrit',en='Burning Strike',skillchain_a='Impaction'},   
    [547] = {id=547,avatar='Ifrit',en='Double Punch',skillchain_a='Compression'},
    [550] = {id=550,avatar='Ifrit',en='Flaming Crush',skillchain_a='Fusion',skillchain_b='Reverberation'},
    [560] = {id=560,avatar='Titan',en='Rock Throw',skillchain_a='Scission'},
    [562] = {id=562,avatar='Titan',en='Rock Buster',skillchain_a='Reverberation'},
    [563] = {id=563,avatar='Titan',en='Megalith Throw',skillchain_a='Induration'},
    [566] = {id=566,avatar='Titan',en='Mountain Buster',skillchain_a='Gravitation',skillchain_b='Induration'},
	[570] = {id=570,avatar='Titan',en='Crag Throw',skillchain_a='Gravitation',skillchain_b='Scission'},
    [576] = {id=576,avatar='Leviathan',en='Barracuda Dive',skillchain_a='Reverberation'},
    [578] = {id=578,avatar='Leviathan',en='Tail Whip',skillchain_a='Detonation'},
    [582] = {id=582,avatar='Leviathan',en='Spinning Dive',skillchain_a='Distortion',skillchain_b='Detonation'},
    [592] = {id=592,avatar='Garuda',en='Claw',skillchain_a='Detonation'},
    [598] = {id=598,avatar='Garuda',en='Predator Claws',skillchain_a='Fragmentation',skillchain_b='Scission'},
    [608] = {id=608,avatar='Shiva',en='Axe Kick',skillchain_a='Induration'},
    [612] = {id=612,avatar='Shiva',en='Double Slap',skillchain_a='Scission'},
    [614] = {id=614,avatar='Shiva',en='Rush',skillchain_a='Distortion',skillchain_b='Scission'},
    [624] = {id=624,avatar='Ramuh',en='Shock Strike',skillchain_a='Impaction'}, 
    [630] = {id=630,avatar='Ramuh',en='Chaotic Strike',skillchain_a='Fragmentation',skillchain_b='Transfixion'},
	[634] = {id=634,avatar='Ramuh',en="Volt Strike",skillchain_a='Fragmentation',skillchain_b='Scission'},
    [656] = {id=656,avatar='Diabolos',en='Camisado',skillchain_a='Compression'},
	[667] = {id=667,avatar='Diabolos',en='Blindside',skillchain_a='Gravitation',skillchain_b='Transfixion'},
    }
    
blue_magic = L{
    [519] = {id=519,en='Screwdriver',skillchain_a='Transfixion',skillchain_b='Scission'},
    [529] = {id=529,en='Bludgeon',skillchain_a='Liquefaction',skillchain_b=''},
    [527] = {id=527,en='Smite of Rage',skillchain_a='Detonation',skillchain_b=''},
    [539] = {id=539,en='Terror Touch',skillchain_a='Compression',skillchain_b='Reverberation'},
    [540] = {id=540,en='Spinal Cleave',skillchain_a='Scission',skillchain_b='Detonation'},
    [543] = {id=543,en='Mandibular Bite',skillchain_a='Induration',skillchain_b=''},
    [545] = {id=545,en='Sickle Slash',skillchain_a='Compression',skillchain_b=''},
    [551] = {id=551,en='Power Attack',skillchain_a='Reverberation',skillchain_b=''},
    [554] = {id=554,en='Death Scissors',skillchain_a='Compression',skillchain_b='Reverberation'},
    [560] = {id=560,en='Frenetic Rip',skillchain_a='Induration',skillchain_b=''},
    [564] = {id=564,en='Body Slam',skillchain_a='Impaction',skillchain_b=''},
    [567] = {id=567,en='Helldive',skillchain_a='Transfixion',skillchain_b=''},
    [569] = {id=569,en='Jet Stream',skillchain_a='Impaction',skillchain_b=''},
    [577] = {id=577,en='Foot Kick',skillchain_a='Detonation',skillchain_b=''},
    [585] = {id=585,en='Ram Charge',skillchain_a='Fragmentation',skillchain_b=''},
    [587] = {id=587,en='Claw Cyclone',skillchain_a='Scission',skillchain_b=''},
    [589] = {id=589,en='Dimensional Death',skillchain_a='Transfixion',skillchain_b='Impaction'},
    [594] = {id=594,en='Uppercut',skillchain_a='Liquefaction',skillchain_b='Impaction'},
    [596] = {id=596,en='Pinecone Bomb',skillchain_a='Liquefaction',skillchain_b=''},
    [597] = {id=597,en='Sprout Smack',skillchain_a='Reverberation',skillchain_b=''},
    [599] = {id=599,en='Queasyshroom',skillchain_a='Compression',skillchain_b=''},
    [603] = {id=603,en='Wild Oats',skillchain_a='Transfixion',skillchain_b=''},
    [611] = {id=611,en='Disseverment',skillchain_a='Distortion',skillchain_b=''},     
    [617] = {id=617,en='Vertical Cleave',skillchain_a='Gravitation',skillchain_b=''},
    [620] = {id=620,en='Battle Dance',skillchain_a='Impaction',skillchain_b=''},
    [622] = {id=622,en='Grand Slam',skillchain_a='Induration',skillchain_b=''},
    [623] = {id=623,en='Head Butt',skillchain_a='Impaction',skillchain_b=''},
    [628] = {id=628,en='Frypan',skillchain_a='Impaction',skillchain_b=''},
    [631] = {id=631,en='Hydro Shot',skillchain_a='Reverberation',skillchain_b=''},
    [638] = {id=638,en='Feather Storm',skillchain_a='Transfixion',skillchain_b=''},
    [640] = {id=640,en='Tail Slap',skillchain_a='Reverberation',skillchain_b=''},
    [641] = {id=641,en='Hysteric Barrage',skillchain_a='Detonation',skillchain_b=''},
    [643] = {id=643,en='Cannonball',skillchain_a='Fusion',skillchain_b=''},
    [650] = {id=650,en='Seedspray',skillchain_a='Induration',skillchain_b='Detonation'},
    [652] = {id=652,en='Spiral Spin',skillchain_a='Transfixion',skillchain_b=''},      
    [653] = {id=653,en='Asuran Claws',skillchain_a='Liquefaction',skillchain_b='Impaction'},
    [654] = {id=654,en='Sub\-zero Smash',skillchain_a='Fragmentation',skillchain_b=''},
    [665] = {id=665,en='Final Sting',skillchain_a='Fusion',skillchain_b=''},
    [666] = {id=666,en='Goblin Rush',skillchain_a='Fusion',skillchain_b=''},
    [667] = {id=667,en='Vanity Dive',skillchain_a='Transfixion',skillchain_b='Scission'},
    [669] = {id=669,en='Whirl of Rage',skillchain_a='Scission',skillchain_b='Detonation'},
    [670] = {id=670,en='Benthic Typhoon',skillchain_a='Gravitation',skillchain_b='Transfixion'},
    [673] = {id=673,en='Quad. Continuum',skillchain_a='Distortion',skillchain_b='Scission'},
    [677] = {id=677,en='Empty Thrash',skillchain_a='Compression',skillchain_b='Scission'},
    [682] = {id=682,en='Delta Thrust',skillchain_a='Liquefaction',skillchain_b='Detonation'},
    [688] = {id=688,en='Heavy Strike',skillchain_a='Fragmentation',skillchain_b=''},
    [692] = {id=692,en='Sudden Lunge',skillchain_a='Scission',skillchain_b=''},
    [693] = {id=693,en='Quadrastrike',skillchain_a='Liquefaction',skillchain_b='Scission'},
    [697] = {id=697,en='Amorphic Spikes',skillchain_a='Gravitation',skillchain_b=''},
    [699] = {id=699,en='Barbed Crescent',skillchain_a='Distortion',skillchain_b='Liquefaction'},
    [743] = {id=743,en='Bloodrake',skillchain_a='Darkness',skillchain_b='Gravitation'},
    } 

npc_move = L{
    -- Automaton
    [1940] = {id=1940,en='Chimera Ripper',skillchain_a='Detonation',skillchain_b='Induration'},
    [1941] = {id=1941,en='String Clipper',skillchain_a='Scission',skillchain_b='Scission'},
    [1942] = {id=1942,en='Arcuballista',skillchain_a='Liquefaction',skillchain_b='Transfixion'},
    [1943] = {id=1943,en='Slapstick',skillchain_a='Reverberation',skillchain_b='Impaction'},
    [2065] = {id=2065,en='Cannibal Blade',skillchain_a='Compression',skillchain_b='Reverberation'},
    [2066] = {id=2066,en='Daze',skillchain_a='Impaction',skillchain_b='Transfixion'},
    [2067] = {id=2067,en='Knockout',skillchain_a='Scission',skillchain_b='Detonation'},
    [2300] = {id=2300,en='Armor Piercer',skillchain_a='Gravitation'},
    [2301] = {id=2301,en='Magic Mortar',skillchain_a='Fusion',skillchain_b='Liquefaction'},
    [2743] = {id=2743,en='String Shredder',skillchain_a='Distortion',skillchain_b='Scission'},
    [2744] = {id=2744,en='Armor Shatterer',skillchain_a='Fusion',skillchain_b='Impaction'},
	[2299] = {id=2299,en='Bone Crusher',skillchain_a='Fragmentation',skillchain_b=''},
-- Trusts
--[3195] = {id=3195,trust='Zeid',en="Abyssal Drain",skillchain_a='',skillchain_b='',skillchain_c=''},
--[3196] = {id=3196,trust='Zeid',en="Abyssal Strike",skillchain_a='',skillchain_b='',skillchain_c=''},
-- assumed magical [3203] = {id=3203,trust='MihliAliapoh',en='Scouring Bubbles',skillchain_a='',skillchain_b='',skillchain_c=''},
	[3204] = {id=3204,trust='Tenzen',en='Amatsu: Tsukikage',skillchain_a='Fragmentation',skillchain_b='Detonation',skillchain_c=''},
	[3215] = {id=3215,trust='NajaSalaheem',en="Peacebreaker",skillchain_a='Fragmentation',skillchain_b='',skillchain_c=''},
	--[3224] = {id=3224,trust='',en="Hemorrhaze",skillchain_a='',skillchain_b='',skillchain_c=''},
	[3231] = {id=3231,trust='LehkoHabhoka',en='Debonair Rush',skillchain_a='Detonation',skillchain_b='',skillchain_c=''},
	--[3232] = {id=3232,trust='LehkoHabhoka',en='Iridal Pierce',skillchain_a='Light',skillchain_b='Fragmentation',skillchain_c=''},
	--[3233] = {id=3233,trust='LehkoHabhoka',en='Lunar Revolution',skillchain_a='Gravitation',skillchain_b='Reverberation',skillchain_c=''},
	[3234] = {id=3234,trust='Prishe',en="Nullifying Dropkick",skillchain_a='Induration',skillchain_b='',skillchain_c=''},
	[3235] = {id=3235,trust='Prishe',en="Auroral Uppercut",skillchain_a='Fragmentation',skillchain_b='',skillchain_c=''},
	[3236] = {id=3236,trust='Prishe',en="Knuckle Sandwich",skillchain_a='Fusion',skillchain_b='',skillchain_c=''},
	--[3238] = {id=3238,trust='Gadalar',en="Salamander Flame",skillchain_a='',skillchain_b='',skillchain_c=''},
	--[3239] = {id=3239,trust='Najelith',en='Typhonic Arrow',skillchain_a='',skillchain_b='',skillchain_c=''},
	[3240] = {id=3240,trust='Zarag',en='Meteoric Impact',skillchain_a='Fragmentation',skillchain_b='',skillchain_c=''},
	[3243] = {id=3243,trust='Nashmeira',en='Imperial Authority',skillchain_a='Fragmentation',skillchain_b='',skillchain_c=''},
	[3252] = {id=3252,trust='Luzaf',en="Bisection",skillchain_a='Fragmentation',skillchain_b='Scission'},
	[3434] = {id=3434,trust='Gilgamesh',en="Tachi: Kamai",skillchain_a='Gravitation',skillchain_b='Darkness'},
	[3435] = {id=3435,trust='Gilgamesh',en="Iainuki",skillchain_a='Fragmentation',skillchain_b='Compression'},
	[3436] = {id=3436,trust='Gilgamesh',en="Tachi: Goten",skillchain_a='Transfixion',skillchain_b='Impaction'},
	[3437] = {id=3437,trust='Gilgamesh',en="Tachi: Kasha",skillchain_a='Fusion',skillchain_b='Compression'},
	[3293] = {id=3293,trust='Excenmille',en="Stag's Charge",skillchain_a='Gravitation',skillchain_b='Transfixion'},
	[3294] = {id=3294,trust='Excenmille',en="Orcsbane",skillchain_a='Distortion',skillchain_b='Compression'},
	[3295] = {id=3295,trust='Excenmille',en="Songbird Swoop",skillchain_a='Fusion',skillchain_b='Reverberation'},
	[3580] = {id=3580,trust='Arciela',en="Harmonic Displacement",skillchain_a='Fusion',skillchain_b='Reverberation'},
	[3454] = {id=3454,trust='Mayakov',en="Coming Up Roses",skillchain_a='Fragmentation',skillchain_b=''},
	[3591] = {id=3591,trust='August',en="Tartaric Sigil",skillchain_a='Compression',skillchain_b='Scission'},
	[3592] = {id=3592,trust='August',en="Null Field",skillchain_a='Fusion',skillchain_b='Transfixion'},
	[3593] = {id=3593,trust='August',en="Alabaster Burst",skillchain_a='Distortion',skillchain_b='Detonation'},
	[3594] = {id=3594,trust='August',en="Noble Frenzy",skillchain_a='Gravitation',skillchain_b=''},
	[3595] = {id=3595,trust='August',en="Fluminous Fury",skillchain_a='Fragmentation',skillchain_b=''},
	[3596] = {id=3596,trust='August',en="No Quarter",skillchain_a='Light',skillchain_b='Distortion'},
	[3677] = {id=3677,trust='Morimar',en="Camaraderie of the Crevasse",skillchain_a='Detonation',skillchain_b='Impaction'},
	[3678] = {id=3678,trust='Morimar',en="Into the Light",skillchain_a='Fragmentation',skillchain_b='Impaction'},
	[3679] = {id=3679,trust='Morimar',en="Arduous Decision",skillchain_a='Fragmentation',skillchain_b='Compression'},
	[3680] = {id=3680,trust='Morimar',en="12 Blades of Remorse",skillchain_a='Distortion',skillchain_b=''},
	[3582] = {id=3582,trust='Arciela',en="Darkest Hour",skillchain_a='Gravitation',skillchain_b=''},
	[3585] = {id=3585,trust='Arciela',en="Naakual's Vengeance",skillchain_a='Induration',skillchain_b=''},
	[3413] = {id=3413,trust='Maat',en="Combo",skillchain_a='Impaction',skillchain_b=''},
	[3414] = {id=3414,trust='Maat',en="One-Ilm Punch",skillchain_a='Compression',skillchain_b=''},
	[3415] = {id=3415,trust='Maat',en="Howling Fist",skillchain_a='Impaction',skillchain_b='Transfixion'},
	[3416] = {id=3416,trust='Maat',en="Dragon Kick",skillchain_a='Fragmentation',skillchain_b=''},
	[3417] = {id=3417,trust='Maat',en="Asuran Fists",skillchain_a='Gravitation',skillchain_b='Liquefaction'},
	[3263] = {id=3263,trust='Maat',en="Bear Killer",skillchain_a='Reverberation',skillchain_b=''},
	[3253] = {id=3253,trust='Luzaf',en='Leaden Salute',skillchain_a='Gravitation',skillchain_b='Transfixion',skillchain_c=''},
	[3254] = {id=3254,trust='Luzaf',en='Akimbo Shot',skillchain_a='Reverberation',skillchain_b='Detonation',skillchain_c=''},
	[3255] = {id=3255,trust='Luzaf',en="Grisly Horizon",skillchain_a='Gravitation',skillchain_b='',skillchain_c=''},
	[3337] = {id=3337,trust='Karaha-Baruha',en='Lunar Bay',skillchain_a='Gravitation',skillchain_b='',skillchain_c=''},
	[3691] = {id=3691,trust='KingofHearts',en='Bludgeon',skillchain_a='Fusion',skillchain_b='Liquefaction',skillchain_c=''},
	[3740] = {id=3740,trust='Shantotto',en='Final Exam',skillchain_a='Light',skillchain_b='Fusion',skillchain_c=''},
	[3741] = {id=3741,trust='Shantotto',en="Doctor's Orders",skillchain_a='Gravitation',skillchain_b='',skillchain_c=''},
	[3742] = {id=3742,trust='Shantotto',en='Empirical Research',skillchain_a='Fragmentation',skillchain_b='Transfixion',skillchain_c=''},
	[3743] = {id=3743,trust='Shantotto',en='Lessons in Pain',skillchain_a='Scission',skillchain_b='Distortion',skillchain_c=''},
	[3692] = {id=3692,trust='KingofHearts',en='Deal Out',skillchain_a='Distortion',skillchain_b='',skillchain_c=''},
	[3470] = {id=3470,trust='Mildaurion',en='Great Wheel',skillchain_a='Fragmentation',skillchain_b='Scission',skillchain_c=''},
	[3471] = {id=3471,trust='Mildaurion',en='Light Blade',skillchain_a='Fusion',skillchain_b='',skillchain_c=''},
	[3472] = {id=3472,trust='Mildaurion',en='Vortex',skillchain_a='Distortion',skillchain_b='Reverberation',skillchain_c=''},
	[3473] = {id=3473,trust='Mildaurion',en='Stellar Burst',skillchain_a='Gravitation',skillchain_b='',skillchain_c=''},
	[3732] = {id=3732,trust='Iroha',en='Amatsu: Fuga',skillchain_a='Impaction',skillchain_b='',skillchain_c=''},
	[3500] = {id=3500,trust='Flaviria',en="Celidon's Torment",skillchain_a='Light',skillchain_b='Fragmentation',skillchain_c=''},
	[3733] = {id=3733,trust='Iroha',en='Amatsu: Kyori',skillchain_a='Induration',skillchain_b='',skillchain_c=''},
	[3734] = {id=3734,trust='Iroha',en='Amatsu: Hanadoki',skillchain_a='Reverberation',skillchain_b='Scission',skillchain_c=''},
	[3735] = {id=3735,trust='Iroha',en='Amatsu: Choun',skillchain_a='Liquefaction',skillchain_b='',skillchain_c=''},
	[3736] = {id=3736,trust='Iroha',en='Amatsu: Gachirin',skillchain_a='Light',skillchain_b='Fragmentation',skillchain_c=''},
	[3737] = {id=3737,trust='Iroha',en='Amatsu: Suien',skillchain_a='Fusion',skillchain_b='Liquefaction',skillchain_c=''},
	[3310] = {id=3310,trust='Lilisette',en="Dancer's Fury",skillchain_a='Fragmentation',skillchain_b='',skillchain_c=''},
	[3311] = {id=3311,trust='Lilisette',en='Whirling Edge',skillchain_a='Distortion',skillchain_b='',skillchain_c=''},
	--[3355] = {id=3355,trust='Abenzio',en='Blow',skillchain_a='',skillchain_b='',skillchain_c=''},
	--[3356] = {id=3356,trust='Abenzio',en='Uppercut',skillchain_a='Liquefaction',skillchain_b='Impaction',skillchain_c=''},
	--[3357] = {id=3357,trust='Abenzio',en='Antiphase',skillchain_a='',skillchain_b='',skillchain_c=''},
	--[3358] = {id=3358,trust='Abenzio',en='Blank Gaze',skillchain_a='',skillchain_b='',skillchain_c=''},
	[3418] = {id=3418,trust='Tenzen',en='Amatsu: Torimai',skillchain_a='Transfixion',skillchain_b='Scission',skillchain_c=''},
	[3419] = {id=3419,trust='Tenzen',en='Amatsu: Kazakiri',skillchain_a='Scission',skillchain_b='Detonation',skillchain_c=''},
	[3420] = {id=3420,trust='Tenzen',en='Amatsu: Yukiarashi',skillchain_a='Induration',skillchain_b='Detonation',skillchain_c=''},
	[3421] = {id=3421,trust='Tenzen',en='Amatsu: Tsukioboro',skillchain_a='Distortion',skillchain_b='Reverberation',skillchain_c=''},
	[3422] = {id=3422,trust='Tenzen',en='Amatsu: Hanaikusa',skillchain_a='Fusion',skillchain_b='Compression',skillchain_c=''},
	[3424] = {id=3424,trust='NanaaMihgo',en='Dancing Edge',skillchain_a='Scission',skillchain_b='Detonation',skillchain_c=''},
	[3189] = {id=3189,trust='NanaaMihgo',en='King Cobra Clamp',skillchain_a='Fragmentation',skillchain_b='',skillchain_c=''},
	[3423] = {id=3423,trust='NanaaMihgo',en='Wasp Sting',skillchain_a='Scission',skillchain_b='',skillchain_c=''},
	[3438] = {id=3438,trust='Areuhat',en='Dragon Breath',skillchain_a='Light',skillchain_b='Fusion',skillchain_c=''},
	[3439] = {id=3439,trust='Areuhat',en='Hurricane Wing',skillchain_a='Detonation',skillchain_b='',skillchain_c=''},
	[3487] = {id=3487,trust='SemihLafihna',en='Sidewinder',skillchain_a='Reverberation',skillchain_b='Transfixion',skillchain_c='Detonation'},
	[3488] = {id=3488,trust='SemihLafihna',en='Arching Arrow',skillchain_a='Fusion',skillchain_b='',skillchain_c=''},
	[3491] = {id=3491,trust='Lion',en='Grapeshot',skillchain_a='Transfixion',skillchain_b='Reverberation',skillchain_c=''},
	[3492] = {id=3492,trust='Lion',en='Pirate Pummel',skillchain_a='Fusion',skillchain_b='',skillchain_c=''},
	[3493] = {id=3493,trust='Lion',en='Powder Keg',skillchain_a='Fusion',skillchain_b='Compression',skillchain_c=''},
	[3494] = {id=3494,trust='Lion',en='Walk the Plank',skillchain_a='Light',skillchain_b='Distortion',skillchain_c=''},
	[3495] = {id=3495,trust='Zeid',en='Ground Strike',skillchain_a='Fragmentation',skillchain_b='Distortion',skillchain_c=''},
	[3715] = {id=3715,trust='AAMR',en='Rampage',skillchain_a='Scission',skillchain_b='',skillchain_c=''},
	[3716] = {id=3716,trust='AAMR',en='Calamity',skillchain_a='Scission',skillchain_b='Impaction',skillchain_c=''},
	[3717] = {id=3717,trust='AAMR',en='Havoc Spiral',skillchain_a='',skillchain_b='',skillchain_c=''},
	[3718] = {id=3718,trust='AAMR',en='Cloudsplitter',skillchain_a='Darkness',skillchain_b='Fragmentation',skillchain_c=''},
    -- Jug Pet
    [3840] = {id=3840,en='Foot Kick',skillchain_a='Reverberation',skillchain_b=''},
    [3842] = {id=3842,en='Whirl Claws',skillchain_a='Impaction',skillchain_b=''},
    [3843] = {id=3843,en='Head Butt',skillchain_a='Detonation',skillchain_b=''},
    [3845] = {id=3845,en='Wild Oats',skillchain_a='Transfixion',skillchain_b=''},
    [3846] = {id=3846,en='Leaf Dagger',skillchain_a='Scission',skillchain_b=''},
    [3849] = {id=3849,en='Razor Fang',skillchain_a='Impaction',skillchain_b=''},
    [3850] = {id=3850,en='Claw Cyclone',skillchain_a='Scission',skillchain_b=''},
    [3851] = {id=3851,en='Tail Blow',skillchain_a='Impaction',skillchain_b=''},
    [3853] = {id=3853,en='Blockhead',skillchain_a='Reverberation',skillchain_b=''},
    [3854] = {id=3854,en='Brain Crush',skillchain_a='Liquefaction',skillchain_b=''},
    [3857] = {id=3857,en='Lamb Chop',skillchain_a='Impaction',skillchain_b=''},
    [3859] = {id=3859,en='Sheep Charge',skillchain_a='Reverberation',skillchain_b=''},
    [3863] = {id=3863,en='Big Scissor',skillchain_a='Scission',skillchain_b=''},
    [3866] = {id=3866,en='Needleshot',skillchain_a='Transfixion',skillchain_b=''},
    [3867] = {id=3867,en='??? Needles',skillchain_a='Darkness',skillchain_b='Fragmentation'},
    [3868] = {id=3868,en='Frog Kick',skillchain_a='Compression',skillchain_b=''},
    [3875] = {id=3875,en='Power Attack',skillchain_a='Induration',skillchain_b=''},
    [3877] = {id=3877,en='Rhino Attack',skillchain_a='Detonation',skillchain_b=''},
    [3885] = {id=3885,en='Mandibular Bite',skillchain_a='Detonation',skillchain_b=''},
    [3891] = {id=3891,en='Nimble Snap',skillchain_a='Impaction',skillchain_b=''},
    [3892] = {id=3892,en='Cyclotail',skillchain_a='Impaction',skillchain_b=''},
    [3894] = {id=3894,en='Double Claw',skillchain_a='Liquefaction',skillchain_b=''},
    [3895] = {id=3895,en='Grapple',skillchain_a='Reverberation',skillchain_b=''},
    [3897] = {id=3897,en='Spinning Top',skillchain_a='Impaction',skillchain_b=''},
    [3900] = {id=3900,en='Suction',skillchain_a='Compression',skillchain_b=''},
    [3904] = {id=3904,en='Sudden Lunge',skillchain_a='Impaction',skillchain_b=''},
    [3905] = {id=3905,en='Spiral Spin',skillchain_a='Scission',skillchain_b=''},
    [3909] = {id=3909,en='Scythe Tail',skillchain_a='Liquefaction',skillchain_b=''},
    [3910] = {id=3910,en='Ripper Fang',skillchain_a='Induration',skillchain_b=''},
    [3911] = {id=3911,en='Chomp Rush',skillchain_a='Darkness',skillchain_b='Gravitation'},
    [3915] = {id=3915,en='Back Heel',skillchain_a='Reverberation',skillchain_b=''},
    [3919] = {id=3919,en='Tortoise Stomp',skillchain_a='Liquefaction',skillchain_b=''},
    [3922] = {id=3922,en='Wing Slap',skillchain_a='Gravitation',skillchain_b='Liquefaction'},
    [3923] = {id=3923,en='Beak Lunge',skillchain_a='Scission',skillchain_b=''},
    [3925] = {id=3925,en='Recoil Dive',skillchain_a='Transfixion',skillchain_b=''},
    [3927] = {id=3927,en='Sensilla Blades',skillchain_a='Scission',skillchain_b=''},
    [3928] = {id=3928,en='Tegmina Buffet',skillchain_a='Distortion',skillchain_b='Detonation'},
    [3930] = {id=3930,en='Swooping Frenzy',skillchain_a='Fusion',skillchain_b='Reverberation'},
    [3931] = {id=3931,en='Sweeping Gouge',skillchain_a='Induration',skillchain_b=''},
    [3933] = {id=3933,en='Pentapeck',skillchain_a='Distortion',skillchain_b='Light'},
    [3934] = {id=3934,en='Tickling Tendrils',skillchain_a='Impaction',skillchain_b=''},
    [3938] = {id=3938,en='Somersault',skillchain_a='Compression',skillchain_b=''},
    [3941] = {id=3941,en='Pecking Flurry',skillchain_a='Transfixion',skillchain_b=''},
    [3942] = {id=3942,en='Sickle Slash',skillchain_a='Transfixion',skillchain_b=''},
    }
	
pet_moves = T{
    [3840] = {id=3840,en='Foot Kick',skillchain_a='Reverberation',skillchain_b=''},
    [3842] = {id=3842,en='Whirl Claws',skillchain_a='Impaction',skillchain_b=''},
    [3843] = {id=3843,en='Head Butt',skillchain_a='Detonation',skillchain_b=''},
    [3845] = {id=3845,en='Wild Oats',skillchain_a='Transfixion',skillchain_b=''},
    [3846] = {id=3846,en='Leaf Dagger',skillchain_a='Scission',skillchain_b=''},
    [3849] = {id=3849,en='Razor Fang',skillchain_a='Impaction',skillchain_b=''},
    [3850] = {id=3850,en='Claw Cyclone',skillchain_a='Scission',skillchain_b=''},
    [3851] = {id=3851,en='Tail Blow',skillchain_a='Impaction',skillchain_b=''},
    [3853] = {id=3853,en='Blockhead',skillchain_a='Reverberation',skillchain_b=''},
    [3854] = {id=3854,en='Brain Crush',skillchain_a='Liquefaction',skillchain_b=''},
    [3857] = {id=3857,en='Lamb Chop',skillchain_a='Impaction',skillchain_b=''},
    [3859] = {id=3859,en='Sheep Charge',skillchain_a='Reverberation',skillchain_b=''},
    [3863] = {id=3863,en='Big Scissor',skillchain_a='Scission',skillchain_b=''},
    [3866] = {id=3866,en='Needleshot',skillchain_a='Transfixion',skillchain_b=''},
    [3867] = {id=3867,en='??? Needles',skillchain_a='Darkness',skillchain_b='Fragmentation'},
    [3868] = {id=3868,en='Frog Kick',skillchain_a='Compression',skillchain_b=''},
    [3875] = {id=3875,en='Power Attack',skillchain_a='Induration',skillchain_b=''},
    [3877] = {id=3877,en='Rhino Attack',skillchain_a='Detonation',skillchain_b=''},
    [3885] = {id=3885,en='Mandibular Bite',skillchain_a='Detonation',skillchain_b=''},
    [3891] = {id=3891,en='Nimble Snap',skillchain_a='Impaction',skillchain_b=''},
    [3892] = {id=3892,en='Cyclotail',skillchain_a='Impaction',skillchain_b=''},
    [3894] = {id=3894,en='Double Claw',skillchain_a='Liquefaction',skillchain_b=''},
    [3895] = {id=3895,en='Grapple',skillchain_a='Reverberation',skillchain_b=''},
    [3897] = {id=3897,en='Spinning Top',skillchain_a='Impaction',skillchain_b=''},
    [3900] = {id=3900,en='Suction',skillchain_a='Compression',skillchain_b=''},
    [3904] = {id=3904,en='Sudden Lunge',skillchain_a='Impaction',skillchain_b=''},
    [3905] = {id=3905,en='Spiral Spin',skillchain_a='Scission',skillchain_b=''},
    [3909] = {id=3909,en='Scythe Tail',skillchain_a='Liquefaction',skillchain_b=''},
    [3910] = {id=3910,en='Ripper Fang',skillchain_a='Induration',skillchain_b=''},
    [3911] = {id=3911,en='Chomp Rush',skillchain_a='Darkness',skillchain_b='Gravitation'},
    [3915] = {id=3915,en='Back Heel',skillchain_a='Reverberation',skillchain_b=''},
    [3919] = {id=3919,en='Tortoise Stomp',skillchain_a='Liquefaction',skillchain_b=''},
    [3922] = {id=3922,en='Wing Slap',skillchain_a='Gravitation',skillchain_b='Liquefaction'},
    [3923] = {id=3923,en='Beak Lunge',skillchain_a='Scission',skillchain_b=''},
    [3925] = {id=3925,en='Recoil Dive',skillchain_a='Transfixion',skillchain_b=''},
    [3927] = {id=3927,en='Sensilla Blades',skillchain_a='Scission',skillchain_b=''},
    [3928] = {id=3928,en='Tegmina Buffet',skillchain_a='Distortion',skillchain_b='Detonation'},
    [3930] = {id=3930,en='Swooping Frenzy',skillchain_a='Fusion',skillchain_b='Reverberation'},
    [3931] = {id=3931,en='Sweeping Gouge',skillchain_a='Induration',skillchain_b=''},
    [3933] = {id=3933,en='Pentapeck',skillchain_a='Distortion',skillchain_b='Light'},
    [3934] = {id=3934,en='Tickling Tendrils',skillchain_a='Impaction',skillchain_b=''},
    [3938] = {id=3938,en='Somersault',skillchain_a='Compression',skillchain_b=''},
    [3941] = {id=3941,en='Pecking Flurry',skillchain_a='Transfixion',skillchain_b=''},
    [3942] = {id=3942,en='Sickle Slash',skillchain_a='Transfixion',skillchain_b=''},
}

function apply_props(packet,abil,ability)
    if not abil then return end
    local mob_id = packet['Target 1 ID']
    local mob = windower.ffxi.get_mob_by_id(mob_id)
    if not mob or not mob.is_npc or mob.hpp == 0 then return end
    local skillchain = packet['Target 1 Action 1 Has Added Effect'] and skillchains[packet['Target 1 Action 1 Added Effect Message']]
    local now = os.time()
    if skillchain then
        local reson = resonating[mob_id]
        local step = (reson and reson.step or 1) + 1
        local closed
        if lvl3:contains(skillchain) and reson and not reson.closed and reson.active[1] == skillchain and
        (reson.chain or reson.ws.skillchain_a == abil.skillchain_a) then
            closed = true
        end
		if lvl4:contains(skillchain) then
			closed = true
		end
        resonating[mob_id] = {active={skillchain},timer=now,ws=abil,chain=true,closed=closed,step=step}
    elseif L{110,161,162,185,187}:contains(packet['Target 1 Action 1 Message']) then 
		local aeonic,aftermath_lvl = aeonicinfo()
		if radiance_ws:contains(abil.en) or umbra_ws:contains(abil.en) then 
			if aeonic and aftermath_lvl then 
				abil.skillchain_c = aftermath_props[abil.en].skillchain_c
				abil.skillchain_b = aftermath_props[abil.en].skillchain_b
				abil.skillchain_a = aftermath_props[abil.en].skillchain_a
			else 
				abil.skillchain_c = ''
				abil.skillchain_b = aftermath_props[abil.en].skillchain_c
				abil.skillchain_a = aftermath_props[abil.en].skillchain_b
			end
		end
        resonating[mob_id] = {active={abil.skillchain_a,abil.skillchain_b,abil.skillchain_c},timer=now,ws=abil,chain=false,step=1}
    elseif L{317}:contains(packet['Target 1 Action 1 Message']) then
        resonating[mob_id] = {active={abil.skillchain_a},timer=now,ws=abil,chain=false,step=1}
    elseif ability == 'spells' and chain_ability.sch[packet.Actor] then
        resonating[mob_id] = {active={active},timer=now,ws=abil,chain=false,step=1}
        chain_ability.sch[packet.Actor] = nil
    elseif ability == 'blue_magic' and packet['Target 1 Action 1 Message'] == 2 and 
    (chain_ability.azure[packet.Actor] or chain_ability.blu[packet.Actor]) then
        resonating[mob_id] = {active={abil.skillchain_a,abil.skillchain_b},timer=now,ws=abil,chain=false,step=1}
        chain_ability.blu[packet.Actor] = nil
    end
    
    if not resonating[mob_id] then return end
    
    for k,element in ipairs(resonating[mob_id].active) do
        if element == '' then resonating[mob_id].active[k] = nil end
    end
end

function delete_timer(dur,...)
    coroutine.schedule(function(...)
        local args = {...}
        return function()
          chain_ability[args[1]][args[2]] = nil
        end
    end(...), dur)
end

function burst_results(reson)
    local stra,strb = '',''
    for k,element in ipairs(reson.active) do
        stra = stra..' [%s]':format(element)
        if settings.ma and reson.chain then
            strb = strb..'\n (Burst: %s)':format(prop_info[element].elements)
        end
    end
    return stra,strb
end

function chain_results(reson)
    local skills,spells,petskills,petskills_ext = {},{},{},{}
    local m_job = windower.ffxi.get_player().main_job
    local abilities = windower.ffxi.get_abilities()
    local spell_table,sch
	local aeonic,aftermath_lvl = aeonicinfo()
    if m_job == 'SMN' then
        spell_table = blood_pacts
    elseif m_job == 'BLU' then
        spell_table = blue_magic
	elseif m_job == 'BST' then
		spell_table = pet_moves
    elseif m_job == 'SCH' and settings.ma then
        sch = true
    end
    for key,element in ipairs(reson.active) do
        local props = prop_info[element].properties
		
        for x=1,#props do
            for k,v in pairs(props[x]) do
                local lvl = prop_info[v].level
                if lvl3:contains(v) and lvl3:contains(element) then
                    lvl = 4
                end
                if sch then
                    for i=0,7 do
                        if elements[i].sc == v then
                            local term = elements[i].mb..' Magic'                        
                            if not spells[term] or spells[term].lvl < lvl then
                                spells[term] = {lvl=lvl,prop=v}
                            end
                        end
                    end
                elseif spell_table then
                    for i,t in ipairs(abilities.job_abilities) do
                        local spell = spell_table[t]
                        if spell and S{spell.skillchain_a,spell.skillchain_b}:contains(k) then
                            local term = spell.en
                            if spell.avatar then term = spell.avatar..': '..term end
                            if (not spells[term] or spells[term].lvl < lvl) then
                                spells[term] = {lvl=lvl,prop=v}
                            end
                        end
                    end
                end
                if settings.ws then
					if m_job == 'BST' and settings.hidews == true then	
						-- Don't show any normal Melee WS :D
					else
						for i,t in ipairs(abilities.weapon_skills) do
							local ws = res.weapon_skills[t]
							
							if radiance_ws:contains(ws.en) or umbra_ws:contains(ws.en) then		
								if aeonic and aftermath_lvl and reson.step > 0 then
									ws.skillchain_c = aftermath_props[ws.en].skillchain_c
									ws.skillchain_b = aftermath_props[ws.en].skillchain_b
									ws.skillchain_a = aftermath_props[ws.en].skillchain_a
								end
							end
							
							if ws and S{ws.skillchain_a,ws.skillchain_b,ws.skillchain_c}:contains(k) and
							(not skills[ws.en] or skills[ws.en].lvl < lvl) then
								skills[ws.en] = {lvl=lvl,prop=v}
							end
						end
					end
					if m_job == 'BST' then
						petskills = pet_skills()
						for index,value in pairs(petskills) do
							for index2,value2 in pairs(pet_moves) do
								if value == value2.en then
									if S{value2.skillchain_a,value2.skillchain_b}:contains(k) then
										petskills_ext[value] = {lvl=lvl,prop=v}
									end
								end
							
							end
						end
					end
                end
            end
        end
    end
    return {[1]=skills,[2]=spells,[3]=petskills_ext}
end

function pet_skills()
	local abilities = windower.ffxi.get_abilities()
	local petskills = {}
	if windower.ffxi.get_mob_by_target('pet') then 
		pet = windower.ffxi.get_mob_by_index(windower.ffxi.get_mob_by_target('pet').index or 0)
	else 
		pet = nil
	end
	if pet then 
		for key,ability in pairs(abilities.job_abilities) do
			local ability_en = res.job_abilities[ability].en
			local ability_targets = res.job_abilities[ability].targets
			local ability_type = res.job_abilities[ability].type
			local ability_charges = res.job_abilities[ability].mp_cost
			if ability_targets.Self == true and ability_type == 'Monster' then
				table.insert(petskills, ability_en)
			end
		end
	end
	return petskills
end

function search_pet_moves(k)
	for i,v in pairs(pet_moves) do
		if v.en == k then
			return true
		end
	end
end

function aeonicinfo()
	
	local buffs = windower.ffxi.get_player().buffs
	local gear = windower.ffxi.get_items()
	local mainweapon = res.items[windower.ffxi.get_items(gear.equipment.main_bag, gear.equipment.main).id].en
	local aftermath_lvl = nil
	local aeonic_found = nil
	
	for i,v in pairs(buffs) do
		if v == 272 then
			aftermath_lvl = 3
		elseif v == 271 then
			aftermath_lvl = 2
		elseif v == 270 then
			aftermath_lvl = 1
		end
	end
	
	if aeonic_weapons:contains(mainweapon) then 
		aeonic_found = true
	end
	
	return aeonic_found,aftermath_lvl
end


function display_results(targ)
    local str = ''
    local results = chain_results(resonating[targ])
    local chain,burst = burst_results(resonating[targ])
    for x = 1,4 do
        for i,t in ipairs(results) do
            for k,v in pairs(t) do
                if v and v.lvl == x then
					if search_pet_moves(k) then 
						str = '\n \\cs(0,255,0)%s\\cs(255,255,255)  >> Lv.%d %s ':format(k,v.lvl,v.prop)..str
					else
						str = '\n %s  >> Lv.%d %s ':format(k,v.lvl,v.prop)..str
					end
                end
            end
        end
    end
    return ' Step: %d >> [%s] >>':format(resonating[targ].step,resonating[targ].ws.en)..chain..burst..str
end

-- SCOPE: bounded symmetric countdown and aligned recommendation grid
local images = require('images')
-- Persistent user HUD preferences (separate from original skillchain settings).
local hud_preferences = config.load({hud_enabled=true,hud_scale=1,hud_x=650,hud_y=95,audio_enabled=false,audio_countdown=true,audio_started=true,audio_burst=true}, 'reforged_hud')
local hud = {enabled=hud_preferences.hud_enabled~=false,scale=tonumber(hud_preferences.hud_scale) or 1,x=tonumber(hud_preferences.hud_x) or 650,y=tonumber(hud_preferences.hud_y) or 95,shown=false}
hud.audio_enabled=hud_preferences.audio_enabled==true
hud.audio_countdown=hud_preferences.audio_countdown~=false
hud.audio_started=hud_preferences.audio_started~=false
hud.audio_burst=hud_preferences.audio_burst~=false
local function save_hud_preferences()
 hud_preferences.hud_enabled=hud.enabled;hud_preferences.hud_scale=hud.scale
 hud_preferences.hud_x=hud.x;hud_preferences.hud_y=hud.y
 hud_preferences.audio_enabled=hud.audio_enabled;hud_preferences.audio_countdown=hud.audio_countdown
 hud_preferences.audio_started=hud.audio_started;hud_preferences.audio_burst=hud.audio_burst
 config.save(hud_preferences, 'reforged_hud')
end

local asset_dir = windower.addon_path .. 'assets/'
local function new_image(filename)
 local obj=images.new({texture={path=asset_dir..filename},pos={x=0,y=0},size={width=1,height=1},draggable=false})
 obj:hide();return obj
end
-- Native stroke avoids duplicated text layers appearing in front of glyphs.
local text_shadows={}
local function hud_text(size)
 local cfg={pos={x=0,y=0},text={font='Segoe UI Semibold',size=size,color={255,245,218},stroke={width=2,alpha=210,red=0,green=0,blue=0}},bg={visible=false,alpha=0},flags={draggable=false}}
 local t=texts.new('',cfg);t:draggable(false);t:hide();return t
end
hud.pill=new_image('title_pill_soft_v25.png')
hud.left=new_image('bar_empty_v26.png');hud.right=new_image('bar_empty_v26.png')
hud.fill_l=new_image('fill_left_v24.png');hud.fill_r=new_image('fill_right_v24.png')
hud.left_shadow=new_image('line_left_shadow.png');hud.right_shadow=new_image('line_right_shadow.png');hud.fill_l_shadow=new_image('fill_gold_shadow.png');hud.fill_r_shadow=new_image('fill_gold_shadow.png')
hud.title_art=new_image('title_gradient_v24.png');hud.title_shadow=hud_text(20);hud.title=hud_text(20);hud.clock=hud_text(12);hud.burst=hud_text(11);hud.burst_header=hud_text(10);hud.burst_timer=hud_text(10);hud.burst_labels={};hud.burst_icons={}
hud.option_labels={};hud.option_results={};hud.option_icons={}
-- Cache every possible icon once at addon load instead of creating a new
-- texture during combat. First-frame texture initialization caused white flashes.
local icon_cache={}
local function cached_icon(filename)
 if not icon_cache[filename] then
  icon_cache[filename]=new_image(filename)
 end
 return icon_cache[filename]
end
for _,name in ipairs({
 'light','radiance','darkness','umbra','fusion','gravitation',
 'distortion','fragmentation','compression','liquefaction',
 'induration','reverberation','transfixion','scission',
 'detonation','impaction'
}) do cached_icon(name..'.png') end
for _,name in ipairs({'fire','ice','wind','earth','lightning','water','light','darkness'}) do
 cached_icon('element_'..name..'.png')
end
-- Compact mouse-driven settings; coordinates are absolute screen pixels.
local menu_open=false
local menu_x,menu_y=35,155
local menu_bg=new_image('settings_panel_v2.png')
menu_bg:draggable(false)
local menu_title=hud_text(13)
local menu_lines={}
for i=1,9 do menu_lines[i]=hud_text(11) end
local dragging=false
local drag_offset_x,drag_offset_y=0,0
local function update_menu()
 if not menu_open then
  menu_bg:hide();menu_title:hide()
  for _,t in ipairs(menu_lines) do t:hide() end
  return
 end
 menu_bg:pos(menu_x,menu_y);menu_bg:size(344,244);menu_bg:show()
 menu_title:hide()
 for _,t in ipairs(menu_lines) do t:hide() end
 local function put(t,str,x,y,size)
  t:pos(menu_x+x,menu_y+y);t:size(size);t:text(str);t:show()
 end
 -- Values are centered within dedicated, non-overlapping status regions.
 put(menu_lines[1],hud.audio_enabled and 'ON' or 'OFF',196,91,11)
 put(menu_lines[2],string.format('%d%%',math.floor(hud.scale*100+0.5)),191,138,12)
 put(menu_lines[3],hud.audio_started and 'ON' or 'OFF',77,199,7)
 put(menu_lines[4],hud.audio_countdown and 'ON' or 'OFF',203,199,7)
 put(menu_lines[5],hud.audio_burst and 'ON' or 'OFF',297,199,7)
end

local function play_hud_sound(name)
 if not hud.audio_enabled then return end
 local path=windower.addon_path..'sounds/'..name..'.wav'
 if windower.play_sound then pcall(windower.play_sound,path) end
end
local last_audio_id,last_audio_step,last_audio_second,last_burst_id
local function process_audio(reson,remaining,bursting)
 if not hud.audio_enabled then return end
 local identity=tostring(reson.timer)..':'..tostring(reson.step)
 if identity~=last_audio_id then
  last_audio_id=identity;last_audio_second=nil
  if hud.audio_started then play_hud_sound('started') end
 end
 if bursting and last_burst_id~=identity then
  last_burst_id=identity
  if hud.audio_burst then play_hud_sound('burst') end
 end
 local seconds=math.ceil(remaining)
 if hud.audio_countdown and seconds>=1 and seconds<=5 and seconds~=last_audio_second then
  local words={'one','two','three','four','five'}
  play_hud_sound(words[seconds])
 end
 last_audio_second=seconds
end
-- Consume both press AND release; FFXI can react to the release even if
-- the initial press was consumed. Also intercept movement/scroll over panel.
local menu_mouse_capture=false
windower.register_event('mouse',function(event,x,y,delta,blocked)
 if not menu_open and not menu_mouse_capture and not dragging then return end
 -- Windower's mouse callback coordinates are slightly behind the image
 -- overlay coordinates on some UI scales. Align the hit test with the
 -- visible art, rather than moving any of the controls themselves.
 local mouse_align_x,mouse_align_y=12,10
 local px=x-menu_x+mouse_align_x;local py=y-menu_y+mouse_align_y
 local inside=menu_open and px>=0 and px<=344 and py>=0 and py<=244
 if event==2 then
  local capture=menu_mouse_capture or inside or dragging
  if dragging then dragging=false;save_hud_preferences();update_menu() end
  menu_mouse_capture=false
  if capture then return true end
  return
 end
 if event==0 then
  if dragging then hud.x=x-drag_offset_x;hud.y=y-drag_offset_y;update_menu();return true end
  if inside or menu_mouse_capture then return true end
  return
 end
 if event~=1 then
  if inside or menu_mouse_capture then return true end
  return
 end
 if inside then
  menu_mouse_capture=true
  -- Hitboxes follow the visible rectangles in settings_panel_v2.png.
  -- Clicking labels, empty space, or dividers must never change a setting.
  local function hit(x1,y1,x2,y2)
   return px>=x1 and px<=x2 and py>=y1 and py<=y2
  end
  if hit(301,16,327,40) then menu_open=false
  elseif hit(243,85,323,111) then hud.audio_enabled=not hud.audio_enabled
  elseif hit(22,132,83,164) then hud.scale=math.max(.5,math.floor(hud.scale*20-.5)/20)
  elseif hit(261,132,322,164) then hud.scale=math.min(2,math.floor(hud.scale*20+1.5)/20)
  elseif hit(20,180,105,198) then hud.audio_started=not hud.audio_started
  elseif hit(116,180,228,198) then hud.audio_countdown=not hud.audio_countdown
  elseif hit(239,180,324,198) then hud.audio_burst=not hud.audio_burst
  elseif hit(20,199,163,238) then hud.scale=1;hud.x=650;hud.y=95
  elseif hit(181,199,324,238) then menu_open=false
  end
  save_hud_preferences();update_menu();return true
 end
 local cx=hud.x;local cy=hud.y
 if menu_open and x>=cx-190*hud.scale and x<=cx+190*hud.scale and y>=cy-45*hud.scale and y<=cy+85*hud.scale then
  dragging=true;menu_mouse_capture=true
  drag_offset_x=x-hud.x;drag_offset_y=y-hud.y
  update_menu();return true
 end
end)
local function all_hud_images()
 local a={hud.pill,hud.title_art,hud.left,hud.right,hud.fill_l,hud.fill_r,hud.left_shadow,hud.right_shadow,hud.fill_l_shadow,hud.fill_r_shadow}
 for _,im in ipairs(hud.option_icons) do a[#a+1]=im end
 for _,im in ipairs(hud.burst_icons) do a[#a+1]=im end
 for _,im in pairs(icon_cache) do a[#a+1]=im end
 return a
end
local function hide_hud()
 for _,im in ipairs(all_hud_images()) do im:hide() end
 for _,t in ipairs({hud.title_shadow,hud.title,hud.clock,hud.burst,hud.burst_header,hud.burst_timer}) do t:hide() end
 for _,t in ipairs(hud.option_labels) do t:hide() end
 for _,t in ipairs(hud.option_results) do t:hide() end
 for _,t in ipairs(hud.burst_labels) do t:hide() end
 for _,shadow in pairs(text_shadows) do shadow:hide() end
 hud.shown=false
end
local function render_hud_preview()
 -- A static layout preview for repositioning; no fake skillchain or sounds.
 local bar=310;local left_x=-445;local right_x=135
 local function pp(img,x,y,w,h)
  local z=hud.scale
  img:pos(hud.x+x*z,hud.y+y*z)
  img:size(math.max(1,w*z),math.max(1,h*z))
  img:show()
 end
 pp(hud.pill,-188,-44,376,119)
 pp(hud.title_art,-155,1,310,49)
 pp(hud.left,left_x,-8,bar,5);pp(hud.right,right_x,-8,bar,5)
 pp(hud.fill_l,left_x,-8,bar,5);pp(hud.fill_r,right_x,-8,bar,5)
 local function pt(t,str,x,y,size)
  t:pos(hud.x+x*hud.scale,hud.y+y*hud.scale)
  t:size(math.max(7,size*hud.scale));t:text(str);t:show()
 end
 pt(hud.clock,'CHAIN NOW  5.0s',-72,-28,12)
 pt(hud.burst,'MAGIC BURST NOW  5.0s',-95,46,11)
end
local function place(img,x,y,w,h)
 local s=hud.scale;img:pos(hud.x+x*s,hud.y+y*s)
 img:size(math.max(1,math.floor(w*s)),math.max(1,math.floor(h*s)))
end
local function label(t,txt,x,y,size)
 local scale=hud.scale
 t:pos(hud.x+x*scale,hud.y+y*scale)
 t:size(math.max(7,math.floor(size*scale)))
 t:text(txt);t:show()
end
local property_rgb={Light={255,223,135},Radiance={255,235,170},Darkness={184,125,255},Umbra={163,111,255},Fusion={255,122,103},Gravitation={201,156,112},Distortion={107,188,255},Fragmentation={242,169,232},Compression={173,140,245},Liquefaction={255,105,84},Induration={130,229,255},Reverberation={107,165,255},Transfixion={250,240,210},Scission={217,170,104},Detonation={137,230,165},Impaction={233,150,250}}
local function colorize(value,rgb)
 rgb=rgb or {235,230,215};return ('\\cs(%d,%d,%d)%s\\cr'):format(rgb[1],rgb[2],rgb[3],tostring(value))
end
local function suggestions(reson)
 if reson.hud_options then return reson.hud_options end
 local ok,results=pcall(chain_results,reson);local options={}
 if ok and results then
  for group_index,group in ipairs(results) do
   for name,info in pairs(group) do
    if info and info.lvl and info.prop then options[#options+1]={name=name,lvl=info.lvl,prop=info.prop,group=group_index} end
   end
  end
 end
 table.sort(options,function(a,b) if a.lvl~=b.lvl then return a.lvl>b.lvl end if a.prop~=b.prop then return a.prop<b.prop end return a.name<b.name end)
 reson.hud_options=options;return options
end
local function render_hud(reson,elapsed)
 for _,shadow in pairs(text_shadows) do shadow:hide() end
 -- Soft translucent backing, positioned behind all three header lines.
 place(hud.pill,-188,-44,376,119);hud.pill:show()
 local duration=reson.chain and 10 or math.max(1,10-(reson.step-1))
 local remain=math.max(0,duration-elapsed)
 local fraction=math.max(0,math.min(1,remain/duration))
 -- The two gold fills retract from the outer ends toward the centered title.
 local bar=310;local filled=math.floor(bar*fraction)
 -- Extend tracks toward the center oval and outward; keep the bar thin.
 local left_x=-445;local right_x=135;local bar_y=-8;local bar_h=5
 place(hud.left_shadow,left_x,bar_y+2,bar,bar_h);place(hud.right_shadow,right_x,bar_y+2,bar,bar_h)
 hud.left_shadow:hide();hud.right_shadow:hide()
 place(hud.left,left_x,bar_y,bar,bar_h);place(hud.right,right_x,bar_y,bar,bar_h)
 if filled>0 then
  place(hud.fill_l,left_x+(bar-filled),bar_y,filled,bar_h)
  place(hud.fill_r,right_x,bar_y,filled,bar_h)
  place(hud.fill_l_shadow,left_x+(bar-filled),bar_y+2,filled,bar_h)
  place(hud.fill_r_shadow,right_x,bar_y+2,filled,bar_h)
  hud.fill_l_shadow:show();hud.fill_r_shadow:show()
  hud.fill_l:show();hud.fill_r:show()
 else hud.fill_l:hide();hud.fill_r:hide();hud.fill_l_shadow:hide();hud.fill_r_shadow:hide() end
 hud.left:show();hud.right:show()
 local burst_prop=reson.chain and reson.active and reson.active[1]
 local burst_data=burst_prop and prop_info[burst_prop]
 local bursting=burst_data and burst_data.elements and remain>0
 process_audio(reson,remain,bursting)
 -- Both statuses are centered in the same header, with a subtle flash when active.
 local pulse=(math.sin(os.clock()*6)+1)/2
 local gold={235+math.floor(20*pulse),205+math.floor(28*pulse),148+math.floor(40*pulse)}
 label(hud.clock,colorize(string.format('CHAIN NOW  %.1fs',remain),gold),-72,-28,12)
 hud.title_shadow:hide();hud.title:hide()
 place(hud.title_art,-155,1,310,49);hud.title_art:show()
 if bursting then
  local blue={105+math.floor(55*pulse),200+math.floor(40*pulse),235+math.floor(20*pulse)}
  label(hud.burst,colorize(string.format('MAGIC BURST NOW  %.1fs',remain),blue),-95,46,11)
 else hud.burst:hide() end
 local opts=suggestions(reson)
 -- Fixed left/right zones: recommendations never collide with burst icons.
 -- Each WS is a two-line, evenly spaced cell; extra choices wrap downward.
 -- Responsive recommendations, confined to the left gold bar's footprint.
 -- 1-2: large; 3-4: medium; 5+: three compact columns.
 local count=#opts
 local columns,cell,rowheight,name_size,prop_size,icon_size,name_limit
 if count<=2 then
  columns=math.max(1,count);cell=158;rowheight=35
  name_size=12;prop_size=11;icon_size=19;name_limit=19
 elseif count<=4 then
  columns=2;cell=153;rowheight=34
  name_size=11;prop_size=10;icon_size=17;name_limit=17
 else
  columns=3;cell=103;rowheight=35
  name_size=9;prop_size=8;icon_size=15;name_limit=12
 end
 -- Left bar begins at -445 and ends at -135; keep recommendations clear of the title.
 local group_left=-472
 for i,opt in ipairs(opts) do
  if not hud.option_labels[i] then hud.option_labels[i]=hud_text(11) end
  if not hud.option_results[i] then hud.option_results[i]=hud_text(10) end
  local wanted=(opt.prop or 'light'):lower()..'.png'
  hud.option_icon_names=hud.option_icon_names or {}
  if hud.option_icon_names[i]~=wanted then
   if hud.option_icons[i] then hud.option_icons[i]:hide() end
   hud.option_icons[i]=cached_icon(wanted);hud.option_icon_names[i]=wanted
  end
  local col=(i-1)%columns;local row=math.floor((i-1)/columns)
  local xx=group_left+col*cell;local yy=14+row*rowheight
  local name=opt.name
  if #name>name_limit then name=name:sub(1,name_limit-2)..'..' end
  local text_x=xx+icon_size+5
  label(hud.option_labels[i],colorize(name,{255,249,238}),text_x,yy,name_size)
  place(hud.option_icons[i],xx,yy+11,icon_size,icon_size);hud.option_icons[i]:show()
  local result=opt.prop..' Lv.'..tostring(opt.lvl)
  -- Compact properties are shortened only when necessary to fit their cell.
  if columns==3 and #result>14 then result=opt.prop:sub(1,10)..'..'..' Lv.'..tostring(opt.lvl) end
  label(hud.option_results[i],colorize(result,property_rgb[opt.prop]),text_x,yy+17,prop_size)
 end
 for i=#opts+1,#hud.option_labels do hud.option_labels[i]:hide() end
 for i=#opts+1,#hud.option_results do hud.option_results[i]:hide() end
 for i=#opts+1,#hud.option_icons do hud.option_icons[i]:hide() end
 hud.burst_header:hide()
 if bursting then
  hud.burst_timer:hide()
  local n=0
  for element in burst_data.elements:gmatch('%S+') do
   n=n+1
   hud.burst_icon_names=hud.burst_icon_names or {}
   if hud.burst_icon_names[n]~=element then
    if hud.burst_icons[n] then hud.burst_icons[n]:hide() end
    hud.burst_icons[n]=cached_icon('element_'..element:lower()..'.png')
    hud.burst_icon_names[n]=element
   end
   if not hud.burst_labels[n] then hud.burst_labels[n]=hud_text(9) end
   -- Aligned icon + label pairs on right; wrap only when needed.
   local col=(n-1)%4;local row=math.floor((n-1)/4)
   local xx=192+col*48;local yy=10+row*57
   place(hud.burst_icons[n],xx,yy,34,34);hud.burst_icons[n]:show()
   local rgb=({Fire={255,113,75},Ice={132,222,255},Wind={128,239,172},Earth={230,180,113},Lightning={195,155,255},Water={116,183,255},Light={255,231,164},Darkness={200,142,255}})[element]
   label(hud.burst_labels[n],colorize(element,rgb),xx-2,yy+35,9) -- clear readable element name
  end
  for i=n+1,#hud.burst_icons do hud.burst_icons[i]:hide() end
  for i=n+1,#hud.burst_labels do hud.burst_labels[i]:hide() end
 else
  hud.burst:hide();hud.burst_timer:hide();hud.burst_header:hide()
  for _,im in ipairs(hud.burst_icons) do im:hide() end
  for _,t in ipairs(hud.burst_labels) do t:hide() end
 end
 hud.shown=true
end
windower.register_event('prerender', function()
    local targ=windower.ffxi.get_mob_by_target('t')
    local now=os.time()
    for id,reson in pairs(resonating) do
        local duration=reson.chain and 10 or math.max(1,10-((reson.step or 1)-1))
        if not reson.timer or now-reson.timer>=duration then
            resonating[id]=nil
        end
    end
    local reson=targ and resonating[targ.id]
    if hud.enabled then
        skill_props:hide()
        if targ and targ.hpp>0 and reson then
            render_hud(reson,now-reson.timer)
        else
            hide_hud()
            if menu_open then render_hud_preview() end
            last_audio_id=nil;last_audio_second=nil;last_burst_id=nil
        end
    else
        hide_hud()
        if targ and targ.hpp>0 and reson and not reson.closed then
            if not reson.disp_info then reson.disp_info=display_results(targ.id) end
            skill_props:text(reson.disp_info)
            skill_props:show()
        elseif not visible then skill_props:hide() end
    end
end)

windower.register_event('incoming chunk', function(id,original,modified,injected,blocked)
    if id == 0x028 then
        local packet = packets.parse('incoming', original)
        -- Weapon Skill finish
        if packet['Category'] == 3 then
            local abil = res.weapon_skills[packet.Param]
            if abil and abil.skillchain_a and abil.skillchain_a ~= '' then
                apply_props(packet,abil,'weapon_skills')
            end
        -- Casting finish
        elseif packet['Category'] == 4 and packet['Target 1 Action 1 Message'] ~= 252 then
            local abil = res.spells[packet.Param]
            if abil and abil.skill == 43 then
                abil = blue_magic[packet.Param]
                apply_props(packet,abil,'blue_magic')
            elseif abil and abil.skill == 36 then
				if elements[abil.element] then 
                abil.skillchain_a = elements[abil.element].sc
                apply_props(packet,abil,'spells')
				end
            end
        -- Job Ability
        elseif packet['Category'] == 6 then
            if packet.Param == 93 then
                chain_ability.azure[packet.Actor] = true
                delete_timer(40,'azure',packet.Actor)
            elseif packet.Param == 94 then
                chain_ability.blu[packet.Actor] = true
                delete_timer(30,'blu',packet.Actor)
            elseif packet.Param == 317 then
                chain_ability.sch[packet.Actor] = true
                delete_timer(60,'sch',packet.Actor)
            --elseif packet.Param == 320 then
            end
        -- NPC TP finish
        elseif packet['Category'] == 11 then
            local abil = npc_move[packet.Param]
            if abil then
                apply_props(packet,abil,'monster_abilities')
            end
        -- Avatar TP finish
        elseif packet['Category'] == 13 then
            local abil = blood_pacts[packet.Param]
            if abil then
                apply_props(packet,abil,'job_abilities')
            end
        end
    end
end)

windower.register_event('addon command', function(...)
    local commands = {...}
    for x=1,#commands do commands[x] = commands[x]:lower() end
    if commands[1] == 'settings' then
        menu_open=not menu_open;update_menu();return
    elseif commands[1] == 'hud' then
        local action=commands[2] or 'settings'
        if action == 'settings' or action == 'menu' then menu_open=not menu_open
        elseif action == 'off' then hud.enabled=false;hide_hud()
        elseif action == 'on' then hud.enabled=true
        elseif action == 'scale' then
            local v=tonumber(commands[3]);if v then hud.scale=math.max(0.5,math.min(2.0,v)) end
        elseif action == 'bigger' or action == '+' then hud.scale=math.min(2.0,math.floor(hud.scale*10+1.5)/10)
        elseif action == 'smaller' or action == '-' then hud.scale=math.max(0.5,math.floor(hud.scale*10-0.5)/10)
        elseif action == 'pos' then
            hud.x=tonumber(commands[3]) or hud.x;hud.y=tonumber(commands[4]) or hud.y
        elseif action == 'right' then hud.x=hud.x+20
        elseif action == 'left' then hud.x=hud.x-20
        elseif action == 'up' then hud.y=hud.y-20
        elseif action == 'down' then hud.y=hud.y+20
        elseif action == 'reset' then hud.enabled=true;hud.scale=1;hud.x=650;hud.y=95
        else windower.add_to_chat(207,'Integrity/DPT HUD: //scope settings | //scope hud scale 1.0 | //scope hud reset') end
        save_hud_preferences();update_menu()
    elseif commands[1] == 'move' then
        visible = true
        if not skill_props:visible() then
            skill_props:text('\n    --- SCOPE ---\n\n  Click and drag to move display.  \n\n\t')
            skill_props:show()
            return
        end
        visible = false
    elseif S{'ma','ws','hidews'}:contains(commands[1]) then
        if not commands[2] then
            settings[commands[1]] = not settings[commands[1]]
        elseif commands[2] == 'off' then
            settings[commands[1]] = false
        elseif commands[2] == 'on' then
            settings[commands[1]] = true
        end
        --windower.add_to_chat(207, '%s will %s be displayed.':format(commands[1] == 'ma' and 'Magic' or 'Weapon Skills',settings[commands[1]] and 'now' or 'NOT'))
		windower.add_to_chat(207, '%s: %s.':format(commands[1],settings[commands[1]] and 'TRUE' or 'FALSE'))
	elseif commands[1] == 'save' then
        config.save(settings, 'all')
    elseif commands[1] == 'eval' then
        assert(loadstring(table.concat(commands, ' ',2)))()
    end
end)

function reset()
    chain_ability = {azure={},sch={},blu={}}
    resonating = {}
end

windower.register_event('load','zone change','logout', reset)