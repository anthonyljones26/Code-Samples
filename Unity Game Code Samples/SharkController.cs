using UnityEngine;
using System.Collections;

public class SharkController : MonoBehaviour
{
    
    public float lifetime = 10f;
    public float attackPower = 10f;
    public Animator animator;
    public float startTime;
    public sharkStates currentState;
    public sharkStates lastState;
    public float waitTime;
    
    public bool towardTheBoat = true;
    public bool attackBacon = false;
    public float swimTime;
    public float swimSpeed;
    public float swimCounter;
    public float preAttackTime;
    public int getBaconState;
    public bool hit = false;
    public float hitAnimationTime;
    public bool hasobjects = false;
    public int frames = 0;
    public int interval = 5;
    public AudioSource audioSource;
    public AudioClip splash;
    public AudioClip smack;
    public int points = 25;
    public int hitCount = 1;
    public float hitDelay = 0f;
    public GameObject tropicalTheme;
    public GameObject townTheme;
    public GameObject arcticTheme;
    public GameObject volcanoTheme;
    public GameObject pirateTheme;
    public GameObject trashTheme;
    public EnemyItem currentItemsScript;
    public bool isPaused = false;
    public bool playerIdle = true;
    public GameObject boatOar;
    public BoatOar boatOarClass;
    public GameObject baconGO;
    public Bounds rbs; //bacon spot
    public Bounds rg; //this.gameobject 
    public Bounds rs; //screen edge 
    public Bounds pr; //
    public Bounds rb;

    
    //needed gameobjects
    public GameObject baconSpot;
    public GameObject boatEdge;
    public GameObject screenEdge;
    public GameObject playerHitArea;
    //public GameObject playerZone;
    public float jumpAngle;
    public float jumpSpeed;
    public bool catAttack = false;
    //grabBaconEvent(baconSpot.name);
    public float chaosAmount;
    public bool hasTheme = false;

    //private shark variables
    private float alertCounter;
    private CookingController baconSpotScript;
    private bool goRight;
    private float preAttackCounter;
    private float hitTime;
    private bool bite = false;

    public enum sharkStates
    {
        alert = 0,
        swim,
        preAttack,
        attackBacon,
        attackPlayer,
        escape,
        hit
    }
    
    public delegate void SharkAttackDelegate(float damage);
    public static event SharkAttackDelegate SharkAttackEvent;

    public delegate void SharkPreAttackDelegate(float xPos);
    public static event SharkPreAttackDelegate SharkPreAttackEvent;
    
    public delegate void sharkBaconHandler(string name);
    public static event sharkBaconHandler grabBaconEvent;

    public delegate void SharkSplashDelegate(Vector3 position);
    public static event SharkSplashDelegate splashEvent;

    public delegate void SharkHitDelegate(Vector3 position);
    public static event SharkHitDelegate SharkHitEvent;

    public delegate void SharkPointsDelegate(Vector3 position, int amount);
    public static event SharkPointsDelegate SharkPointsEvent;

    public delegate void SharkChaosDelegate(float chaos);
    public static event SharkChaosDelegate SharkChaosEvent;

    public delegate void SharkTutorialDelegate();
    public static event SharkTutorialDelegate SharkTutorialEvent;

    void OnEnable()
    {
        TouchAreaManager.PlayerIdleEvent += PlayerIdle;
    }
    
    void OnDisable()
    {
        TouchAreaManager.PlayerIdleEvent -= PlayerIdle;
    }

    // Use this for initialization
    void Start()
    {
        animator = gameObject.GetComponent<Animator>();
        audioSource = gameObject.GetComponent<AudioSource>();
        startTime = GameManager.Instance.GameTime();
        baconGO = baconSpotScript.bacon;

        rb = GetBounds(boatEdge);
        
        rbs = GetBounds(baconGO);

        Fire();
    }
    
    public void Fire()
    {
        baconSpotScript = baconSpot.GetComponent<CookingController>();

        if ((transform.position.x) < 0)
        {
            goRight = false;
        } else
        {
             goRight = true;
        }
        baconGO = baconSpotScript.bacon;
        rbs = GetBounds(baconGO);

        if (transform.localScale.x < 1)
        {
            Toolbox.Instance.smallCount++;
        }

        currentState = sharkStates.alert;
        bite = false;
    }
    
    // Update is called once per frame
    void Update()
    {

        if (!GameManager.Instance.paused)
        {
            switch (currentState)
            {
                case sharkStates.alert:
                    Alert();
                    break;
                
                case sharkStates.swim:
                    Swim();
                    break;
                
                case sharkStates.preAttack:
                    PreAttack();
                    break;
                
                case sharkStates.attackPlayer:
                    AttackPlayer();
                    break;
                
                case sharkStates.attackBacon:
                    AttackBacon();
                    break;
                case sharkStates.hit:
                    GetHit();
                    break;
                case sharkStates.escape:
                    Escaping();
                    break;
            }


        }
    }

    void LateUpdate()
    {
        frames++;
        if (frames >= interval)
        {
            frames = 0;
            

            if (gameObject.transform.position.x > 15 || gameObject.transform.position.x < -15) 
            {
                if (hasTheme)
                {
                    currentItemsScript.ResetState();
                }
                gameObject.SetActive(false);
            }

            if(gameObject.transform.position.y < -5)
            {
                if (hasTheme)
                {
                    currentItemsScript.ResetState();
                }
                gameObject.SetActive(false);
            }
        }

    }

    public void ParentTrigger(Collider2D collider)
    {
        if (collider.gameObject.tag == "boat_oar")
        {
            if ((currentState != sharkStates.hit || currentState != sharkStates.escape) && playerIdle == false)
            {
                catAttack = false;
                HitHandler();
            }
        }

        if (collider.gameObject.tag == "cat")
        {
            if (currentState != sharkStates.hit || currentState != sharkStates.hit)
            {
                catAttack = true;
                HitHandler();
            }
        }

        if (collider.gameObject.tag == "cat_shield")
        {
            if (currentState != sharkStates.hit || currentState != sharkStates.hit)
            {
                catAttack = true;
                hitCount = 1;
                HitHandler();
            }
        }
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        switch (currentState)
        {
            case sharkStates.swim:
                
                if (towardTheBoat == true)
                {


                    if (collision.gameObject.tag == "boat_edge")
                    {
                        towardTheBoat = false;
                    }
                }
                else
                {
                    if (collision.gameObject.tag == "screen_edge")
                    {
                        towardTheBoat = true;
                    }
                }

                break;
            case sharkStates.attackBacon:
                switch (getBaconState)
                {
                    case 1:
                        if(collision.gameObject.tag == "boat_edge")
                        {
                            transform.Rotate(Vector3.back * 25f);
                            getBaconState = 2;
                        }
                        break;
                    case 2:
                        if(collision.gameObject.tag == "bacon")
                        {
                            grabBaconEvent(baconSpot.name);
                            getBaconState = 3;
                        }
                        break;
                }
                break;
            case sharkStates.attackPlayer:
                if (bite == false)
                {
                    if (collision.gameObject.tag == "Player")
                    {
                        SharkAttackEvent(attackPower);
                        bite = true;
                    }
                }
                break;
        }
    }

    void Alert()
    {
        
        if (animator.GetInteger("shark_int") != 0)
        {
             
            animator.SetInteger("shark_int", 0);
            if (hasTheme)
            {
                currentItemsScript.SetSharkSwimBool(true);
            }
            alertCounter = GameManager.Instance.GameTime() + waitTime;
            
            if (!goRight)
            {
                if (hasTheme)
                {
                    currentItemsScript.currentOrientation = EnemyItem.itemOrientation.flipped;
                }
                gameObject.transform.rotation = new Quaternion(0f, 180f, 0f, 1f);
            } else
            {
                if (hasTheme)
                {
                    currentItemsScript.currentOrientation = EnemyItem.itemOrientation.original;
                }
                gameObject.transform.rotation = new Quaternion(0f, 0f, 0f, 0f);
            }
            
        }
        
        if (GameManager.Instance.GameTime() > alertCounter)
        {
            currentState = sharkStates.swim;
        }
    }
    
    void Swim()
    {
        if (animator.GetInteger("shark_int") != 1)
        {

            animator.SetInteger("shark_int", 1);
            if (hasTheme)
            {
                currentItemsScript.SetSharkSwimBool(true);
            }
           
            int roll = Random.Range(300, 700);
            float rd = roll / 100;
            swimCounter = GameManager.Instance.GameTime() + swimTime + rd;
            towardTheBoat = true;
            
            if (!goRight)
            {
                if (hasTheme)
                {
                    currentItemsScript.currentOrientation = EnemyItem.itemOrientation.flipped;
                }
                transform.rotation = new Quaternion(0f, 180f, 0f, 1f);
            } else
            {
                if (hasTheme)
                {
                    currentItemsScript.currentOrientation = EnemyItem.itemOrientation.original;
                }
                transform.rotation = new Quaternion(0f, 0f, 0f, 0f);
            }
            
        }
        
        int direction = -1;
        if (!goRight)
        {
            direction = -1;
        }
        
        if (towardTheBoat)
        {
            if (goRight)
            {
                if (hasTheme)
                {
                    currentItemsScript.currentOrientation = EnemyItem.itemOrientation.original;
                }
                gameObject.transform.rotation = new Quaternion(0f, 0f, 0f, 1f);
            } else
            {
                if (hasTheme)
                {
                    currentItemsScript.currentOrientation = EnemyItem.itemOrientation.flipped;
                }
                gameObject.transform.rotation = new Quaternion(0f, 180f, 0f, 1f);
            }
            
            transform.Translate(new Vector3(direction * (swimSpeed * GameManager.Instance.DeltaTime()), 0f, 0f));
        } else
        {
            if (goRight)
            {
                if (hasTheme)
                {
                    currentItemsScript.currentOrientation = EnemyItem.itemOrientation.flipped;
                }
                gameObject.transform.rotation = new Quaternion(0f, 180f, 0f, 1f);
            } else
            {
                if (hasTheme)
                {
                    currentItemsScript.currentOrientation = EnemyItem.itemOrientation.original;
                }
                gameObject.transform.rotation = new Quaternion(0f, 0f, 0f, 1f);
            }
            transform.Translate(new Vector3(direction * (swimSpeed * GameManager.Instance.DeltaTime()), 0f, 0f)); 
        }
          
        if (GameManager.Instance.GameTime() > swimCounter)
        {
            currentState = sharkStates.preAttack;
        }
        
    }
    
    void PreAttack()
    {
        if (animator.GetInteger("shark_int") != 2)
        {
            animator.SetInteger("shark_int", 2);
            if (Toolbox.Instance.gData.tutSharkAttack == false) {
                SharkPreAttackEvent(gameObject.transform.position.x);
            }
            if (hasTheme)
            {
                currentItemsScript.SetSharkSwimBool(false);
            }
            //splashEvent(new Vector3(gameObject.transform.position.x,gameObject.transform.position.y + 0.2f, gameObject.transform.position.z));


            preAttackCounter = preAttackTime + GameManager.Instance.GameTime();
            
            if (towardTheBoat == false)
            {
                if (goRight)
                {
                    if (hasTheme)
                    {
                        currentItemsScript.currentOrientation = EnemyItem.itemOrientation.original;
                    }
                    transform.rotation = new Quaternion(0f, 0f, 0f, 1f);
                } else
                {
                    if (hasTheme)
                    {
                        currentItemsScript.currentOrientation = EnemyItem.itemOrientation.flipped;
                    }
                    transform.rotation = new Quaternion(0f, 180, 0f, 1f);
                }
            } else
            {
                // print("keep moving foward");
            }
            transform.Rotate(Vector3.back * 30f);
            
            if (baconSpotScript.hasBacon == false)
            {
                
                attackBacon = false;
            } else
            {
                
                attackBacon = true;
            }
            
        }
        
        if (GameManager.Instance.GameTime() > preAttackCounter)
        {
            if (attackBacon == false)
            {
                currentState = sharkStates.attackPlayer;
                
            } else
            {
                currentState = sharkStates.attackBacon;
            }
           
        }
        
    }
    
    void AttackPlayer()
    {
        if (animator.GetInteger("shark_int") != 3)
        {
            animator.SetInteger("shark_int", 3);
            splashEvent(new Vector3(gameObject.transform.position.x,gameObject.transform.position.y + 0.2f, gameObject.transform.position.z));
            audioSource.clip = splash;
            audioSource.Play();
        }
        
        int direction = -1;
        if (!goRight)
        {
            direction = -1;
        }

        transform.Rotate(Vector3.back * (-22f * GameManager.Instance.DeltaTime()));
        transform.Translate(new Vector3(direction * 9f * GameManager.Instance.DeltaTime(), 0f, 0f));
        
        
    }
    
    void AttackBacon()
    {
        
        if (animator.GetInteger("shark_int") != 4)
        {
            animator.SetInteger("shark_int", 4);
            
            getBaconState = 1;
            
            if (gameObject.transform.rotation.z != 0)
            {
                //print("correct direction");
                if (!goRight)
                {
                    if (hasTheme)
                    {
                        currentItemsScript.currentOrientation = EnemyItem.itemOrientation.flipped;
                    }
                    transform.rotation = new Quaternion(0f, 180f, 0f, 1f);
                } else
                {
                    if (hasTheme)
                    {
                        currentItemsScript.currentOrientation = EnemyItem.itemOrientation.original;
                    }
                    transform.rotation = new Quaternion(0f, 0f, 0f, 0f);
                }
            }
        }
        
        int direction = -1;
        if (!goRight)
        {
            direction = -1;
        }
        
        switch (getBaconState)
        {
            case 1:
                transform.Translate(new Vector3(direction * 7f * GameManager.Instance.DeltaTime(), 0f, 0f));
                break;

            case 2:
                transform.Translate(new Vector3(direction * 7f * GameManager.Instance.DeltaTime(), 0f, 0f));
                break;
            case 3:
                transform.Translate(new Vector3(direction * -4f * GameManager.Instance.DeltaTime(), 0f, 0f));
                break;

        }
       
    }

    public void HitHandler()
    {
        if (hitDelay < GameManager.Instance.GameTime())
        {
            //subtract 1 from hitCount
            if (hitCount > 0)
            {
                if (GameManager.Instance.chaos)
                {
                    hitCount -= 2;
                    if(hitCount < 0)
                    {
                        hitCount = 0;
                    }
                }
                else
                {
                    hitCount--;
                }
                
                if (hasTheme)
                {
                    if (hitCount <= 0 && (GameManager.Instance.chaos || GameManager.Instance.healthCatAttack))
                    {
                        currentItemsScript.currentState = EnemyItem.enemyItemState.none;
                        hitCount = 0;
                    }
                    else
                    {
                        currentItemsScript.currentState = (EnemyItem.enemyItemState)hitCount;
                    }
                    audioSource.clip = smack;
                    audioSource.Play();
                    SharkChaosEvent(chaosAmount);
                }
            }
            //check hitCount
            if (hitCount == 0)
            {
                //old hit code
                currentState = sharkStates.hit;
            }
            else
            {
                //reset hitDelay
                hitDelay = GameManager.Instance.GameTime() + 0.7f;

                //send hit event
                if (catAttack == false)
                {
                    SharkHitEvent(boatOar.transform.position);
                }
                else
                {
                    SharkHitEvent(gameObject.transform.position);
                }
            }

        }
    }


    public void GetHit()
    {
        if ((hit == false) && (currentState != sharkStates.swim))
        {
            if (!Toolbox.Instance.gData.tutSharkAttack)
            {
                SharkTutorialEvent();
            }

            hitTime = GameManager.Instance.GameTime() + hitAnimationTime;
            currentState = sharkStates.hit;
            hit = true;

            /*increment shark hit counter*/
            Toolbox.Instance.sharkHitCount += 1;
            if (catAttack == false)
            {
                SharkHitEvent(boatOar.transform.position);
            }
            else
            {
                SharkHitEvent(gameObject.transform.position);
            }

            if (GameManager.Instance.doublePoints)
            {
                points = points * 2;
            }

            SharkPointsEvent(gameObject.transform.position, points);
            SharkChaosEvent(chaosAmount);
            GameManager.Instance.AddPoints(points);

            if (goRight)
            {
                if (hasTheme)
                {
                    currentItemsScript.currentOrientation = EnemyItem.itemOrientation.original;
                }
                transform.rotation = new Quaternion(0f, 0f, 0f, 0f);
            }
            else
            {
                if (hasTheme)
                {
                    currentItemsScript.currentOrientation = EnemyItem.itemOrientation.flipped;
                }
                transform.rotation = new Quaternion(0f, 180f, 0f, 0f);
            }
            animator.SetInteger("shark_int", 5);
            if (hasTheme)
            {
                currentItemsScript.SetSharkSwimBool(false);
            }
            audioSource.clip = smack;
            audioSource.Play();
            GameManager.Instance.ProcessEvent(GameManager.eventAction.hit, GameManager.eventActionType.sharks);

        }

        if (GameManager.Instance.GameTime() > hitTime)
        {
            currentState = sharkStates.escape;
        }
    }
    
    void Escaping()
    {   
        if (animator.GetInteger("shark_int") != 6)
        {
            hit = false;
            animator.SetInteger("shark_int", 6);
            
            
            if (transform.position.x > 0)
            {
                Quaternion newRotation = transform.rotation;
                newRotation.y = 180f;
                if (hasTheme)
                {
                    currentItemsScript.currentOrientation = EnemyItem.itemOrientation.flipped;
                }
                transform.rotation = newRotation;
            } else
            {
                Quaternion newRotation = transform.rotation;
                newRotation.y = 0f;
                if (hasTheme)
                {
                    currentItemsScript.currentOrientation = EnemyItem.itemOrientation.original;
                }
                transform.rotation = newRotation;
                
            }

        }
        transform.Rotate(Vector3.back * (-32f * GameManager.Instance.DeltaTime()));
        transform.Translate(new Vector3(-1 * (swimSpeed + 10f) * GameManager.Instance.DeltaTime(), 0f, 0f));
        
        if (transform.position.y < -10)
        {
            
            gameObject.SetActive(false);
        }
    }
    
    public Bounds GetBounds(GameObject g)
    {

        Bounds newBounds = new Bounds();
        if(g.GetComponent<BoxCollider2D>())
        {
            newBounds = g.GetComponent<BoxCollider2D>().bounds;
        }
        else if (g.GetComponent<PolygonCollider2D>())
        {
            newBounds = g.GetComponent<PolygonCollider2D>().bounds;
        }
        else if (g.GetComponent<SpriteRenderer>())
        {
            newBounds = g.GetComponent<SpriteRenderer>().bounds;
        }
        
        return newBounds;
    }

    Rect getRect(GameObject g)
    {
        float topleft_x;
        if (goRight)
        {
            topleft_x = g.transform.position.x + g.GetComponent<Renderer>().bounds.size.x / 2;
        } else
        {
            topleft_x = g.transform.position.x - g.GetComponent<Renderer>().bounds.size.x / 2;
        }
        
        float topleft_y = g.transform.position.y + g.GetComponent<Renderer>().bounds.size.y / 2;
        Rect newRect = new Rect(topleft_x, topleft_y, g.GetComponent<Renderer>().bounds.size.x, g.GetComponent<Renderer>().bounds.size.y); 
        
        return newRect;
    }
    
    public bool Intersect(Rect rectA, Rect rectB)
    {
        return (Mathf.Abs(rectA.x - rectB.x) < (Mathf.Abs(rectA.width + rectB.width) / 2)) 
            && (Mathf.Abs(rectA.y - rectB.y) < (Mathf.Abs(rectA.height + rectB.height) / 2));
        
    }

    public void PlayerIdle(bool idle)
    {
        playerIdle = idle;
    }
    
    public void Restore(TargetPackage tp)
    {
        startTime = GameManager.Instance.GameTime();
        baconSpot = tp.bacon;
        playerHitArea = tp.hitArea;
        screenEdge = tp.screenEdge;
        boatEdge = tp.boatEdge;
        boatOar = tp.boatOar;
        points = 25;
        hitCount = tp.hitCount;

        SetTheme();
        Fire();
    }

    public void ResetTheme()
    {
        tropicalTheme.SetActive(false);
        pirateTheme.SetActive(false);
        townTheme.SetActive(false);
        arcticTheme.SetActive(false);
        volcanoTheme.SetActive(false);
        trashTheme.SetActive(false);
        hasTheme = false;
    }

    public void SetTheme()
    {
        ResetTheme();
        if(hitCount > 0)
        {
            switch (GameManager.Instance.currentLandType)
            {
                case LandContainer.LandTypes.glacier:
                    hasTheme = true;
                    arcticTheme.SetActive(true);
                    currentItemsScript = arcticTheme.GetComponent<EnemyItem>();
                    currentItemsScript.currentState = (EnemyItem.enemyItemState)hitCount;
                    break;
                case LandContainer.LandTypes.volcano:
                    hasTheme = true;
                    volcanoTheme.SetActive(true);
                    currentItemsScript = volcanoTheme.GetComponent<EnemyItem>();
                    currentItemsScript.currentState = (EnemyItem.enemyItemState)hitCount;
                    break;
                case LandContainer.LandTypes.town:
                    hasTheme = true;
                    townTheme.SetActive(true);
                    currentItemsScript = townTheme.GetComponent<EnemyItem>();
                    currentItemsScript.currentState = (EnemyItem.enemyItemState)hitCount;
                    break;
                case LandContainer.LandTypes.plain:
                    hasTheme = true;
                    tropicalTheme.SetActive(true);
                    currentItemsScript = tropicalTheme.GetComponent<EnemyItem>();
                    currentItemsScript.currentState = (EnemyItem.enemyItemState)hitCount;
                    break;
                case LandContainer.LandTypes.pirate:
                    hasTheme = true;
                    pirateTheme.SetActive(true);
                    currentItemsScript = pirateTheme.GetComponent<EnemyItem>();
                    currentItemsScript.currentState = (EnemyItem.enemyItemState)hitCount;
                    break;
                case LandContainer.LandTypes.trash:
                    hasTheme = true;
                    trashTheme.SetActive(true);
                    currentItemsScript = trashTheme.GetComponent<EnemyItem>();
                    currentItemsScript.currentState = (EnemyItem.enemyItemState)hitCount;
                    break;
            }
        }
    }
        
}