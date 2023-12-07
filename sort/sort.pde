//the progress function as asked by prof!
boolean bubbleSortProgress(int[] data, boolean sorted, int i, int y) {
    boolean swap = false;
    if (data[i] > data[i + 1]) {
        int temp = data[i];
        data[i] = data[i + 1];
        data[i + 1] = temp;
        sorted = false;   
        swap = true;
    }
    visualizeArray(data,i,y,swap);
    return sorted;
}

//joystick (changable) variables
int maxi = 5;
int desired = 1;
int fontSize = 20;

//utility variables; //not to be changed!
int timer = millis();
boolean scrolling = false;
int cellCize = fontSize + 10;
int scroll = cellCize;
int lineGap;//gap between each line
int[] nums = new int[0];
boolean sorted = false;

//the bubble sort algo
void bubbleSort(int[] data) {
    
    //As I am decding to work by modifying so i will have to store a copy(scroll) and work on it!
    int position = scroll;
    
    //these organized will temporariliry hadle the sorted state and later depending on
    //organized we will update sort! more safe than directly updating sorted!
    boolean oraganized = true;
    for (int i = 0;i <  desired; i++) {
        
        int k = i % (data.length - 1);
        
        //this is the main function that will do the swapping and return the sorted state!
        oraganized = bubbleSortProgress(data, oraganized, k, position);
        
        // these are not part of bubble sort algo rather to stop scrolling!
        if (position == fontSize) scrolling = false;
        
        //update the position for next line!
        position += lineGap;
        
        //whenever a full scan event will trigger we will check if the array is sorted or not! 
        if (k == (data.length - 2)) {
            if (oraganized) {
                sorted = true;
            }
            else oraganized = true;
        }
    }
}


//setup text size , color  and lineGap
void setup() {
    size(600, 400); //canvas
    //maths to calculate the line gap!
    lineGap = ceil(height / maxi);
    lineGap += ((lineGap - fontSize - (cellCize - fontSize)) / (maxi - 1));
    textSize(fontSize); 
    fill(color(0,0,255));//blue
    textAlign(CENTER);
    text("Clicks to start bubble sort stimulation", width / 2, fontSize);
}

boolean terminated = false;
void draw() {
    //there is nothing to scroll more and show so no need to draw anything! 
    if ((sorted || nums.length <=  0) && !scrolling) {
        if (sorted && !terminated) {
            terminated = true;
            text("Sorted!", width - 100 ,height - cellCize - fontSize);
            int gap = lineGap;
        }
        return;
    }
    
    //the way i am implementing scrolling intoroduces a bug called falsy scroll for desired-1!
    //this is a hack to fix that bug!
    if (terminated) return;
    
    
    // clear the screen everytime!
    background(255);
    
    // if thescreen is scrolling then decrease the scroll to make it look like scrolling!
    if (scrolling) {
        scroll --;
    }
    //updatethes crolling state according to the estimation of function
    bubbleSort(nums.clone());
}

//tell aboutif dormancy period is over or not!
boolean isAllowed() { 
    int currentTime = millis();
    int diff = currentTime - timer;
    if (diff > 500) {
        timer = currentTime;
        return true;
    };
    return false;
};

//increase desired by 1 if allowed by timer & if not scrolling
void keyPressed() {
    if (isAllowed() && !scrolling) {
        desired++;
        //screen is overflowing start scrolling!
        if (desired > maxi) scrolling = true;
    }
}

//generate random array of size n with values between start and end
int[] generateRandomArray(int n, int start, int end) {
    int[] array = new int[n];
    for (int i = 0; i < n; i++) {
        array[i] = int(random(start, end));
    }
    return array;
}

//for visualizing the array!
void visualizeArray(int[] data, int enhaceAt, int verticalPos,boolean swap) {
    int x = 5 + cellCize / 2;
    for (int i = 0;i < data.length;i++) {
        int num = data[i];
        boolean important = i ==  enhaceAt || i ==  enhaceAt + 1;
        boolean highlight = important &&  swap;
        arrayCell(x,verticalPos + (cellCize - fontSize),cellCize,str(num),important,highlight);
        x += cellCize;
    }
}

//for visualizing the array!
void arrayCell(int x,int y,int size,String content,boolean important ,boolean highlight) {
    int halfSize = size / 2;
    stroke(255);
    if (important) textSize(fontSize + 5);
    else textSize(fontSize);
    fill(color(0));
    square(x - halfSize,y - size,size);
    fill(highlight ? color(255,0,0) : important ? color(0,0,255) : color(140, 200, 255));
    text(content,x,y - 5);
}

//the mouse click functionality!
void mouseClicked() {
    terminated = false;
    scroll = fontSize;
    desired = 1;
    scrolling = false;
    sorted = false;
    nums = generateRandomArray(5, 1, 100);
}