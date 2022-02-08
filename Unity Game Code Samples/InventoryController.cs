using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class InventoryController : MonoBehaviour
{
    public GameObject coolerGroup;
    public GameObject panGroup;
    public GameObject boatGroup;
    public GameObject catGroup;
    public GameObject oarGroup;

    public GameObject coolerButton;
    public GameObject boatButton;
    public GameObject panButton;
    public GameObject catButton;
    public GameObject oarButton;

    public GameObject playButton;
    public GameObject storeButton;
    public GameObject inventoryButton;
    public GameObject optionsButton;

    public GameObject title;
    public GameObject player;

    public Color normalColor;
    public Color highlight;

    public GameObject coins;
    public GameObject diamonds;

    public GameObject shopSwitch;
    public GameObject shopPanel;
    public float transitionTime;
    public float transitionTimer;
    public Animator animator;
    public MenuController mc;

    public enum inventoryState
    {
        hidden = 0,
        enter,
        exit,
        stationary
    }

    public inventoryState currentState = inventoryState.hidden;

    // Use this for initialization
    void Start()
    {
        ShowCoolerGroup();
        LoadItems();
        animator = GetComponent<Animator>();

    }

    public void LoadItems()
    {
        //coolers
        coolerGroup.GetComponent<EquipmentGroup>().Fill(GameManager.Instance.ownedCoolers);

        //pans
        panGroup.GetComponent<EquipmentGroup>().Fill(GameManager.Instance.ownedPans);

        //boats
        boatGroup.GetComponent<EquipmentGroup>().Fill(GameManager.Instance.ownedBoats);

        //cats
        catGroup.GetComponent<EquipmentGroup>().Fill(GameManager.Instance.ownedCats);

        //oar
        oarGroup.GetComponent<EquipmentGroup>().Fill(GameManager.Instance.ownedOars);

        //gems
        coins.SetActive(true);
        diamonds.SetActive(true);
    }

    public void UpdateAllEquipped()
    {
        //coolers
        coolerGroup.GetComponent<EquipmentGroup>().UpdateEquipped();

        //pans
        panGroup.GetComponent<EquipmentGroup>().UpdateEquipped();

        //boats
        boatGroup.GetComponent<EquipmentGroup>().UpdateEquipped();

        //cats
        catGroup.GetComponent<EquipmentGroup>().UpdateEquipped();

        //oar
        oarGroup.GetComponent<EquipmentGroup>().UpdateEquipped();
    }

    // Update is called once per frame
    void Update()
    {
        switch (currentState)
        {
            case inventoryState.hidden:
                break;
            case inventoryState.stationary:
                break;
            case inventoryState.enter:
                EnterInventory();
                break;
            case inventoryState.exit:
                ExitInventory();
                break;
        }

    }

    public void EnterInventory()
    {
        if (currentState != inventoryState.enter && currentState != inventoryState.stationary)
        {
            currentState = inventoryState.enter;
            animator.SetTrigger("inventoryTrigger");
            transitionTimer = GameManager.Instance.GameTime() + transitionTime;
        }

        if (GameManager.Instance.GameTime() >= transitionTimer)
        {
            currentState = inventoryState.stationary;
        }

    }

    public void ExitInventory()
    {
        if (currentState != inventoryState.exit && currentState != inventoryState.hidden)
        {
            currentState = inventoryState.exit;
            animator.SetTrigger("inventoryTrigger");
            transitionTimer = GameManager.Instance.GameTime() + transitionTime;
        }

        if (GameManager.Instance.GameTime() >= transitionTimer)
        {
            currentState = inventoryState.hidden;
        }
    }

    public void ShowCoolerGroup()
    {
        //unhighlight all buttons
        coolerButton.GetComponent<Image>().color = normalColor;
        panButton.GetComponent<Image>().color = normalColor;
        boatButton.GetComponent<Image>().color = normalColor;
        catButton.GetComponent<Image>().color = normalColor;
        oarButton.GetComponent<Image>().color = normalColor;

        //highlight this button
        coolerButton.GetComponent<Image>().color = highlight;

        //show cooler group
        coolerGroup.SetActive(true);

        //hide other groups
        panGroup.SetActive(false);
        catGroup.SetActive(false);
        boatGroup.SetActive(false);
        oarGroup.SetActive(false);
    }

    public void ShowPanGroup()
    {
        //unhighlight all buttons
        coolerButton.GetComponent<Image>().color = normalColor;
        panButton.GetComponent<Image>().color = normalColor;
        boatButton.GetComponent<Image>().color = normalColor;
        catButton.GetComponent<Image>().color = normalColor;
        oarButton.GetComponent<Image>().color = normalColor;

        //highlight this button
        panButton.GetComponent<Image>().color = highlight;

        //show cooler group
        panGroup.SetActive(true);

        //hide other groups
        coolerGroup.SetActive(false);
        boatGroup.SetActive(false);
        catGroup.SetActive(false);
        oarGroup.SetActive(false);
    }

    public void ShowCatGroup()
    {
        //unhighlight all buttons
        coolerButton.GetComponent<Image>().color = normalColor;
        panButton.GetComponent<Image>().color = normalColor;
        boatButton.GetComponent<Image>().color = normalColor;
        catButton.GetComponent<Image>().color = normalColor;
        oarButton.GetComponent<Image>().color = normalColor;

        //highlight this button
        catButton.GetComponent<Image>().color = highlight;

        //show cooler group
        catGroup.SetActive(true);

        //hide other groups
        panGroup.SetActive(false);
        coolerGroup.SetActive(false);
        boatGroup.SetActive(false);
        oarGroup.SetActive(false);
    }

    public void ShowBoatGroup()
    {
        //unhighlight all buttons
        coolerButton.GetComponent<Image>().color = normalColor;
        panButton.GetComponent<Image>().color = normalColor;
        boatButton.GetComponent<Image>().color = normalColor;
        catButton.GetComponent<Image>().color = normalColor;
        oarButton.GetComponent<Image>().color = normalColor;

        //highlight this button
        boatButton.GetComponent<Image>().color = highlight;

        //show cooler group
        boatGroup.SetActive(true);

        //hide other groups
        panGroup.SetActive(false);
        coolerGroup.SetActive(false);
        catGroup.SetActive(false);
        oarGroup.SetActive(false);
    }

    public void ShowOarGroup()
    {
        //unhighlight all buttons
        coolerButton.GetComponent<Image>().color = normalColor;
        panButton.GetComponent<Image>().color = normalColor;
        boatButton.GetComponent<Image>().color = normalColor;
        catButton.GetComponent<Image>().color = normalColor;
        oarButton.GetComponent<Image>().color = normalColor;

        //highlight this button
        oarButton.GetComponent<Image>().color = highlight;

        //show cooler group
        oarGroup.SetActive(true);

        //hide other groups
        panGroup.SetActive(false);
        coolerGroup.SetActive(false);
        catGroup.SetActive(false);
        boatGroup.SetActive(false);
        //oarGroup.SetActive(false);
    }

    public void CloseInventory()
    {
        mc.ExitMenu();
        Toolbox.Instance.SaveGameData();
    }

    public void ShopSwitch()
    {
        mc.ShowShop();
        gameObject.SetActive(false);
        shopPanel.SetActive(true);
        player.SetActive(true);
    }
}
