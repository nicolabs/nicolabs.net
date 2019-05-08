---
date: 2012-03-01 12:56:02 +0100
tags:
    - android
---

Just look at which data is the largest : Sony Ericsson and SFR (carrier)...

    # busybox ls --color=never -lS /system/media/audio/ringtones
    busybox ls --color=never -lS /system/media/audio/ringtones
    total 2977
    -rw-r--r--    1 0        0           643902 Jan 19  2011 SFR_Ringtone.mp3
    -rw-r--r--    1 0        0           206809 Jan 18  2011 CrazyDream.ogg
    -rw-r--r--    1 0        0           175423 Jan 18  2011 DreamTheme.ogg
    -rw-r--r--    1 0        0           150152 Aug 18  2010 sony_ericsson.ogg
    -rw-r--r--    1 0        0            59024 Jan 18  2011 Ring_Classic_02.ogg
    -rw-r--r--    1 0        0            54923 Jan 18  2011 Glacial_Groove.ogg
    -rw-r--r--    1 0        0            52809 Jan 18  2011 Ring_Synth_02.ogg
    -rw-r--r--    1 0        0            52536 Jan 18  2011 Revelation.ogg
    -rw-r--r--    1 0        0            50578 Jan 18  2011 Eastern_Sky.ogg
    -rw-r--r--    1 0        0            49978 Jan 18  2011 GameOverGuitar.ogg
    -rw-r--r--    1 0        0            49108 Jan 18  2011 Road_Trip.ogg
    -rw-r--r--    1 0        0            46673 Jan 18  2011 Big_Easy.ogg
    -rw-r--r--    1 0        0            46425 Jan 18  2011 FriendlyGhost.ogg
    -rw-r--r--    1 0        0            46049 Jan 18  2011 Thunderfoot.ogg
    -rw-r--r--    1 0        0            44422 Jan 18  2011 Seville.ogg
    -rw-r--r--    1 0        0            43965 Jan 18  2011 Ring_Synth_04.ogg
    -rw-r--r--    1 0        0            41828 Jan 18  2011 BirdLoop.ogg
    -rw-r--r--    1 0        0            41094 Jan 18  2011 Growl.ogg
    -rw-r--r--    1 0        0            39921 Jan 18  2011 Champagne_Edition.ogg
    -rw-r--r--    1 0        0            39738 Jan 18  2011 Funk_Yall.ogg
    -rw-r--r--    1 0        0            39413 Jan 18  2011 Shes_All_That.ogg
    -rw-r--r--    1 0        0            39199 Jan 18  2011 Paradise_Island.ogg
    -rw-r--r--    1 0        0            39174 Jan 18  2011 Bollywood.ogg
    -rw-r--r--    1 0        0            39138 Jan 18  2011 Savannah.ogg
    -rw-r--r--    1 0        0            39025 Jan 18  2011 Noises2.ogg
    -rw-r--r--    1 0        0            38875 Jan 18  2011 Calypso_Steel.ogg
    -rw-r--r--    1 0        0            38688 Jan 18  2011 Gimme_Mo_Town.ogg
    -rw-r--r--    1 0        0            38307 Jan 18  2011 LoopyLounge.ogg
    -rw-r--r--    1 0        0            37847 Jan 18  2011 Steppin_Out.ogg
    -rw-r--r--    1 0        0            37672 Jan 18  2011 Cairo.ogg
    -rw-r--r--    1 0        0            37179 Jan 18  2011 Club_Cubano.ogg
    -rw-r--r--    1 0        0            36620 Jan 18  2011 Terminated.ogg
    -rw-r--r--    1 0        0            36539 Jan 18  2011 Third_Eye.ogg
    -rw-r--r--    1 0        0            36287 Jan 18  2011 Noises1.ogg
    -rw-r--r--    1 0        0            34864 Jan 18  2011 MildlyAlarming.ogg
    -rw-r--r--    1 0        0            34627 Jan 18  2011 LoveFlute.ogg
    -rw-r--r--    1 0        0            32933 Jan 18  2011 No_Limits.ogg
    -rw-r--r--    1 0        0            32640 Jan 18  2011 OrganDub.ogg
    -rw-r--r--    1 0        0            31641 Jan 18  2011 RomancingTheTone.ogg
    -rw-r--r--    1 0        0            31563 Jan 18  2011 EtherShake.ogg
    -rw-r--r--    1 0        0            31136 Jan 18  2011 World.ogg
    -rw-r--r--    1 0        0            30925 Jan 18  2011 CurveBall.ogg
    -rw-r--r--    1 0        0            30759 Jan 18  2011 BentleyDubs.ogg
    -rw-r--r--    1 0        0            30615 Jan 18  2011 CaribbeanIce.ogg
    -rw-r--r--    1 0        0            28898 Jan 18  2011 SitarVsSitar.ogg
    -rw-r--r--    1 0        0            28691 Jan 18  2011 VeryAlarmed.ogg
    -rw-r--r--    1 0        0            28433 Jan 18  2011 BeatPlucker.ogg
    -rw-r--r--    1 0        0            28124 Jan 18  2011 MidEvilJaunt.ogg
    -rw-r--r--    1 0        0            26662 Jan 18  2011 Noises3.ogg
    -rw-r--r--    1 0        0            26298 Jan 18  2011 TwirlAway.ogg
    -rw-r--r--    1 0        0            26144 Jan 18  2011 SpringyJalopy.ogg
    -rw-r--r--    1 0        0            21007 Jan 18  2011 Ring_Digital_02.ogg
    -rw-r--r--    1 0        0            15563 Jan 18  2011 NewPlayer.ogg
    -rw-r--r--    1 0        0            15146 Jan 18  2011 InsertCoin.ogg


    rm /system/app/facebook.apk

    rm -r /data/data/com.facebook.katana



[forum.xda-developers.com/wiki/SE_Xperia_X10_Mini/Freeing_Space](http://forum.xda-developers.com/wiki/SE_Xperia_X10_Mini/Freeing_Space)

[forum.xda-developers.com/showthread.php?p=6710092#post6710092](http://forum.xda-developers.com/showthread.php?p=6710092#post6710092)

[forum.xda-developers.com/wiki/SE_Xperia_X10_Mini/Apps/Default](http://forum.xda-developers.com/wiki/SE_Xperia_X10_Mini/Apps/Default)
