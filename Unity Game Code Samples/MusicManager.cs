using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

public class MusicManager : Singleton<MusicManager> {
    
    public AudioSource audioSource;

    public AudioMixerSnapshot lowA;
    public AudioMixerSnapshot mediumA;
    public AudioMixerSnapshot heavyA;
    public AudioMixerSnapshot epicA;
    public AudioMixerSnapshot menuA;
    public AudioMixerSnapshot pauseA;
    public AudioMixerSnapshot gameOverA;


    public AudioMixer mixer;
    bool fading;


    public enum audioSnapshot
    {
        low = 0,
        medium,
        heavy,
        epic,
        menu,
        pause,
        gameOver
    }

    public string startMenu = "StartMenuVol";
    public string pause = "PauseVol";
    public string low = "LightVol";
    public string medium = "MediumVol";
    public string heavy = "HeavyVol";
    public string gameOver = "GameOverVol";


    public audioSnapshot currentSnapshot = audioSnapshot.menu;
    public audioSnapshot lastSnapshot = audioSnapshot.menu;

    public string currentGroup = "StartMenuVol";
    public string lastGroup = "StartMenuVol";


    // Update is called once per frame
    void Update () {
        if (Input.GetKeyDown(KeyCode.A))
        {
            ChangeToMenu();
        }
        if (Input.GetKeyDown(KeyCode.S))
        {
            ChangeToLight();
        }
        if (Input.GetKeyDown(KeyCode.D))
        {
            ChangeToMedium();
        }
        if (Input.GetKeyDown(KeyCode.F))
        {
            ChangeToHeavy();
        }
        if (Input.GetKeyDown(KeyCode.G))
        {
            ChangeToPause();
        }
        if (Input.GetKeyDown(KeyCode.H))
        {
            ChangeToGameOver();
        }

    }

    public void CrossfadeGroups(float duration, string currentAudio, string nextAudio )
    {
        if (currentAudio != nextAudio)
        {
            if (!fading)
            {
                StartCoroutine(Crossfade(duration, currentAudio, nextAudio));
            }
        }
    }

    IEnumerator Crossfade(float fadeTime,string currentAudio, string nextAudio)
    {
        fading = true;
        float currentTime = 0;

        while (currentTime <= fadeTime)
        {
            currentTime += Time.deltaTime;

            mixer.SetFloat(currentAudio, Mathf.Log10(Mathf.Lerp(1, 0.0001f, currentTime / fadeTime)) * 20);
            mixer.SetFloat(nextAudio, Mathf.Log10(Mathf.Lerp(0.0001f, 1, currentTime / fadeTime)) * 20);

            yield return null;
        }

        fading = false;

    }

    public void ChangeToLight()
    {
        try{
            lastGroup = currentGroup;
            CrossfadeGroups(1f, lastGroup, low);
            currentGroup = low;
        }
        catch{
        }
    }

    public void ChangeToMedium()
    {
        try{
            lastGroup = currentGroup;
            CrossfadeGroups(1f, lastGroup, medium);
            currentGroup = medium;
        }
        catch{
        };

    }

    public void ChangeToHeavy()
    {
        try{
            lastGroup = currentGroup;
            CrossfadeGroups(1f, lastGroup, heavy);
            currentGroup = heavy;
        }
        catch{
        };
    }

    public void ChangeToEpic()
    {
        try
        {
            lastGroup = currentGroup;
            CrossfadeGroups(1f, lastGroup, heavy);
            currentGroup = heavy;
        }
        catch
        {
        };
    }

    public void ChangeToMenu()
    {
        try{
            lastGroup = currentGroup;
            CrossfadeGroups(1f, lastGroup, startMenu);
            currentGroup = startMenu;
        }
        catch{
        };
    }

    public void ChangeToPause()
    {
        try{
            lastGroup = currentGroup;
            CrossfadeGroups(1f, lastGroup, pause);
            currentGroup = pause;
        }
        catch{
        };
    }

    public void ChangeToGameOver()
    {
        try
        {
            lastGroup = currentGroup;
            CrossfadeGroups(1f, lastGroup, gameOver);
            currentGroup = gameOver;
        }
        catch
        {
        };
    }

    public void ChangeToLast()
    {
        switch (lastGroup)
        {
            case "LightVol":
                ChangeToLight();
                break;
            case "MediumVol":
                ChangeToMedium();
                break;
            case "HeavyVol":
                ChangeToHeavy();
                break;
            case "StartMenuVol":
                ChangeToMenu();
                break;
            case "GameOverVol":
                ChangeToGameOver();
                break;
        }
    }

}
