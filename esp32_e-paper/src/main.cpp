#include <Arduino.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h> 

#include <GxEPD2_3C.h>
#include <Adafruit_GFX.h>

#include <Fonts/FreeSansBold12pt7b.h>    
#include <Fonts/FreeSansBold9pt7b.h>     
#include <Fonts/FreeSans9pt7b.h>         
#include <Fonts/FreeSansBold18pt7b.h>    

// DRIVER E-PAPER 
#include </GxEPD2_213_Z19c.h> 

// CẤU HÌNH CHÂN
#define EPD_BUSY  4
#define EPD_RST   16
#define EPD_DC    17
#define EPD_CS    5
#define EPD_CLK   18
#define EPD_MOSI  23

GxEPD2_3C<GxEPD2_213_Z19c, GxEPD2_213_Z19c::HEIGHT> display(
  GxEPD2_213_Z19c(EPD_CS, EPD_DC, EPD_RST, EPD_BUSY)
);

// CẤU HÌNH WIFI & SERVER 
const char* WIFI_SSID     = "t302";   
const char* WIFI_PASSWORD = "889988998899"; 
const char* SERVER_HOST   = "172.31.99.93"; 
const int   SERVER_PORT   = 8000;

const unsigned long FETCH_INTERVAL_MS = 60 * 1000;   
unsigned long lastFetchTime = 0;

// Biến lưu trạng thái để tránh vẽ lại màn hình nếu dữ liệu không đổi
String lastUpdatedCode = ""; 
String lastUpdatedPrice = "";

// KẾT NỐI WIFI
void connectWiFi() {
  Serial.print("Connecting to WiFi");
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  int retry = 0;
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
    if (++retry > 60) { 
      Serial.println("\nFailed to connect WiFi, restarting...");
      ESP.restart();
    }
  }
  Serial.println("\nWiFi connected!");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
}

// VẼ MÃ VẠCH 
void drawFakeBarcode(int x, int y, int w, int h) {
  int currentX = x;
  while (currentX < x + w) {
    int thickness = random(2, 5); 
    if (currentX + thickness > x + w) break;
    display.fillRect(currentX, y, thickness, h, GxEPD_BLACK);
    currentX += thickness + random(1, 3); 
  }
  for (int i = x; i < x + w; i += 4) {
    display.fillRect(i, y + h + 2, 2, 2, GxEPD_BLACK);
  }
}

// VẼ GIAO DIỆN 
void drawLabel(String name, String priceStr, String currentCode)
{
  display.setRotation(1);
  display.init(115200, true, 2, false); 
  display.setFullWindow();
  display.firstPage();
  do
  {
    display.fillScreen(GxEPD_WHITE);

    // TIÊU ĐỀ
    display.setTextColor(GxEPD_BLACK);
    display.setFont(&FreeSansBold12pt7b); 
    display.setCursor(12, 18); 
    display.print(name);

    // COLLECTION
    display.setFont(&FreeSans9pt7b); 
    display.setTextColor(GxEPD_BLACK);
    display.setCursor(10, 33); 
    display.print("Hust Uniforms");
    display.setCursor(10, 47); 
    display.print("collection 2025");

    // BADGE LOGIC 
    int badgeX = 45; int badgeY = 76; int radius = 26; 

    display.fillCircle(badgeX, badgeY, radius, GxEPD_RED);
    display.fillTriangle(badgeX - 15, badgeY + 20, badgeX, badgeY + 25, badgeX - 25, badgeY + 33, GxEPD_RED);

    display.setTextColor(GxEPD_WHITE); 
    display.setFont(&FreeSansBold9pt7b);
    
    // Logic với D001, D003, D005 là SOLD OUT
    if (currentCode == "D001" || currentCode == "D003" || currentCode == "D005") {
        display.setCursor(21, 76); display.print("SOLD");
        display.setCursor(26, 91); display.print("OUT");
    } else {
        display.setCursor(21, 76); display.print("SALE"); 
        display.setCursor(26, 92); display.print("30%"); 
    }

    // GIÁ TIỀN
    display.setTextColor(GxEPD_RED);
    int priceX = 135; int priceY = 70;
    display.setFont(&FreeSansBold12pt7b);
    display.setCursor(priceX, priceY - 10);
    display.print("$");
    display.setFont(&FreeSansBold18pt7b);
    display.setCursor(priceX + 15, priceY); 
    display.print(priceStr);

    // MÃ VẠCH
    drawFakeBarcode(115, 80, 85, 15);
  }
  while (display.nextPage());
  
  display.hibernate(); 
}

// [MỚI] GỬI BÁO CÁO TRẠNG THÁI (PUT)
void reportStatus(String code) {
  if (WiFi.status() != WL_CONNECTED) return;

  HTTPClient http;
  // URL mới: /display/active/status
  String url = String("http://") + SERVER_HOST + ":" + String(SERVER_PORT) + "/display/active/status";
  
  http.begin(url);
  http.addHeader("Content-Type", "application/json");

  // Tạo JSON trạng thái 
  StaticJsonDocument<200> doc;
  doc["rssi"] = WiFi.RSSI();           // Cường độ sóng
  doc["status"] = "online";
  doc["displaying_code"] = code;

  String requestBody;
  serializeJson(doc, requestBody);

  Serial.print("[PUT] Status to: "); Serial.println(url);
  int httpResponseCode = http.PUT(requestBody); // Gửi lệnh PUT

  if (httpResponseCode > 0) {
    Serial.printf("Status Sent. Response: %d\n", httpResponseCode);
  } else {
    Serial.printf("Error Sending Status: %s\n", http.errorToString(httpResponseCode).c_str());
  }
  http.end();
}

// GỌI API LẤY DỮ LIỆU (GET)
void fetchDisplayData() {
  if (WiFi.status() != WL_CONNECTED) {
    connectWiFi();
  }

  HTTPClient http;
  // Fix mã cứng theo display 
  String url = String("http://") + SERVER_HOST + ":" + String(SERVER_PORT) + "/display/active";

  Serial.print("[HTTP] GET "); Serial.println(url);

  http.begin(url);
  int httpCode = http.GET();

  if (httpCode == HTTP_CODE_OK) {
      String payload = http.getString();
      Serial.println("API Response:");
      Serial.println(payload);

      DynamicJsonDocument doc(1024);
      DeserializationError error = deserializeJson(doc, payload);

      if (!error) {
        String pName = doc["product_name"].as<String>();
        float priceFloat = doc["price"].as<float>();
        String pPrice = String((int)priceFloat);
        
        String fetchedCode = doc["code"].as<String>();
        
        Serial.printf("Data: %s - $%s (Code: %s)\n", pName.c_str(), pPrice.c_str(), fetchedCode.c_str());

        drawLabel(pName, pPrice, fetchedCode);

        // Sau khi vẽ xong thành công, báo cáo trạng thái lại cho server
        reportStatus(fetchedCode);
        
      } else {
        Serial.print("JSON Error: ");
        Serial.println(error.c_str());
      }

  } else {
    Serial.printf("HTTP Error: %d\n", httpCode);
  }
  http.end();
}


// SETUP & LOOP
void setup()
{
  Serial.begin(115200);
  delay(1000); 

  pinMode(EPD_RST, OUTPUT);
  digitalWrite(EPD_RST, HIGH); delay(20);
  digitalWrite(EPD_RST, LOW);  delay(20);
  digitalWrite(EPD_RST, HIGH); delay(200);

  Serial.println("--- STARTING E-PAPER (ACTIVE MODE) ---");
  randomSeed(analogRead(0)); 

  connectWiFi();
  
  // Lấy dữ liệu ngay khi khởi động
  fetchDisplayData();
  lastFetchTime = millis();
}

void loop() {
  unsigned long now = millis();
  if (now - lastFetchTime >= FETCH_INTERVAL_MS) {
    fetchDisplayData();
    lastFetchTime = now;
  }
}






