const int trigPin = 9;
const int echoPin = 10;

long duration;

float distance_cm;
float distance_mm;

float totalDistance = 0;
float averageDistance = 0;

void setup() {

  Serial.begin(9600);

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

void loop() {

  totalDistance = 0;

  // Take 10 readings
  for (int i = 0; i < 10; i++) {

    // Clear trigger pin
    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);

    // Send 10us pulse
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);

    // Read echo time
    duration = pulseIn(echoPin, HIGH);

    // Convert to cm
    distance_cm = duration * 0.0343 / 2;

    // Convert to mm
    distance_mm = distance_cm * 10;

    // Add to total
    totalDistance += distance_mm;

    delay(20);
  }

  // Calculate average
  averageDistance = totalDistance / 10;

  // Print averaged distance
  Serial.print("Average Distance: ");
  Serial.print(averageDistance);
  Serial.println(" mm");

  delay(200);
}