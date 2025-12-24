# MG-0008 Flappy Bird - AI 에셋 생성 프롬프트

이 문서는 MG-0008 Flappy Bird 게임에 필요한 그래픽/사운드 에셋을 AI 도구로 생성할 때 사용할 프롬프트 모음입니다.

---

## 🎨 그래픽 에셋

### 1. 새 (Bird) 스프라이트

**현재 구현**: 노란색 원형 + 흰색 눈 + 주황색 부리

**AI 이미지 생성 프롬프트**:
```
Cute pixel art bird sprite for Flappy Bird game,
40x40 pixels, round yellow body, white eye with black pupil,
orange beak, side-view facing right,
simple and friendly design, transparent background,
PNG format, game-ready sprite

Style: pixel art, cute, minimalist
Colors: yellow (#FFFF00), white (#FFFFFF), black (#000000), orange (#FFA500)
Variations needed: idle, flapping (2-3 frames), falling
```

**날개짓 애니메이션**:
```
Pixel art bird wing flap animation sprite sheet,
3 frames showing wing up, middle, down positions,
40x40 pixels per frame, yellow bird with wings,
simple pixel art style, horizontal sprite sheet layout,
transparent background

Frame 1: Wings up
Frame 2: Wings middle (neutral)
Frame 3: Wings down
```

**Midjourney/DALL-E 스타일**:
```
pixel art yellow bird character sprite, Flappy Bird style,
cute round shape, orange beak, white eye, side view,
wing flapping animation frames, retro game art,
transparent background --ar 3:1 --v 5
```

---

### 2. 파이프 (Pipe) 스프라이트

**현재 구현**: 녹색 사각형 (#00AA00) + 캡 (#00CC00)

**AI 이미지 생성 프롬프트**:
```
Pixel art pipe obstacle for Flappy Bird game,
green colored pipe (#00AA00), vertical rectangle,
pipe cap/lip at the end (wider section),
simple retro game style, suitable for tiling vertically,
60 pixels wide, transparent background, PNG format

Style: pixel art, retro, simple geometric
Colors: green (#00AA00), light green (#00CC00), dark green (#008800)
Elements: main pipe body, decorative cap/rim
```

**파이프 변형**:
```
Create 3 pipe style variations:
1. Classic green pipe (original Mario-style)
2. Industrial metal pipe (gray/silver, rivets)
3. Bamboo pipe (natural, segmented sections)

Each: 60 pixels wide, tileable, pixel art style
```

---

### 3. 배경 (Background)

**현재 구현**: 단색 하늘색 (#87CEEB)

**AI 이미지 생성 프롬프트**:
```
Flappy Bird game background, pixel art style,
sky blue (#87CEEB) gradient with fluffy white clouds,
parallax scrolling layers, simple and clean,
1920x1080 resolution, seamless horizontal tiling,
retro mobile game aesthetic

Layers (back to front):
1. Sky gradient (light blue to slightly darker blue)
2. Distant clouds (small, slow parallax)
3. Close clouds (medium size, faster parallax)
4. Optional: distant hills/mountains silhouette

Style: pixel art, cheerful, mobile game
```

**배경 변형 (주/야)**:
```
Day background: bright sky blue (#87CEEB), white clouds, sun
Night background: dark blue (#1a1a3e), stars, crescent moon, darker clouds
Sunset background: orange/pink gradient, dramatic clouds
```

---

### 4. 땅 (Ground) 스프라이트

**현재 구현**: 갈색 땅 (#8b4513) + 녹색 잔디 (#228B22)

**AI 이미지 생성 프롬프트**:
```
Pixel art ground/floor sprite for Flappy Bird game,
brown dirt/earth base (#8b4513) with green grass top (#228B22),
100 pixels height, seamless horizontal tiling,
simple pixel art style, retro game aesthetic,
transparent background on sides, PNG format

Layers:
- Top 20px: Green grass with small pixel tufts
- Middle 60px: Brown earth/dirt texture
- Bottom 20px: Darker brown underground

Style: pixel art, simple, tileable
Colors: green (#228B22), brown (#8b4513), dark brown (#654321)
```

---

### 5. UI 요소

**점수 표시 숫자**:
```
Pixel art number sprites 0-9 for score display,
retro 8-bit style, white color with black outline/shadow,
large and readable (48x64 pixels per digit),
bold and clear font, PNG sprite sheet

Style: pixel art, bold, high contrast
Layout: horizontal sprite sheet (10 digits: 0-9)
```

**게임 오버 배너**:
```
Pixel art "GAME OVER" text banner,
red color with black shadow/outline, bold retro font,
approximately 300x80 pixels, eye-catching design,
suitable for mobile game, PNG format

Optional elements: sad bird icon, retry button
Style: pixel art, impactful, retro game
```

**시작 버튼/텍스트**:
```
Pixel art "TAP TO START" and "TAP TO RESTART" text,
white color with black shadow, medium size (200x40 pixels),
clear and inviting, retro game style, PNG format

Style: pixel art, friendly, clear
```

---

## 🔊 사운드 에셋

### 1. 새 사운드

**날개짓 사운드**:
```
Audio prompt for AI sound generation (e.g., ElevenLabs, Mubert):

"8-bit retro wing flap sound effect for Flappy Bird game,
short 0.15 second duration, soft whoosh sound,
mid-to-high pitched, simple chiptune synthesizer,
friendly and bouncy tone, WAV format"

Parameters:
- Duration: 0.15s
- Pitch: mid (C4-E4)
- Style: chiptune, soft whoosh
- Tone: friendly, bouncy
```

**충돌/사망 사운드**:
```
"8-bit game over crash sound effect, short 0.3 second,
descending pitch with impact, Flappy Bird death sound,
chiptune synthesizer, slightly dramatic but not harsh,
WAV format"

Parameters:
- Duration: 0.3s
- Pitch: descending (E4 to C3)
- Style: chiptune, impact with descend
- Tone: game over, mild dramatic
```

---

### 2. 게임 이벤트 사운드

**점수 획득 사운드**:
```
"8-bit point scored sound effect for Flappy Bird,
very short 0.2 second, ascending pitch ding/bell,
cheerful and rewarding, chiptune synthesizer,
bright and satisfying tone, WAV format"

Parameters:
- Duration: 0.2s
- Pitch: ascending (C4 to C5)
- Style: chiptune, ding/bell tone
- Tone: rewarding, cheerful
```

**파이프 통과 사운드** (대체):
```
"8-bit whoosh/pass sound effect, 0.15 second,
quick high-pitched swoosh, Flappy Bird pipe pass,
chiptune style, subtle and satisfying, WAV format"

Parameters:
- Duration: 0.15s
- Pitch: high (E5-G5)
- Style: chiptune, swoosh
```

---

### 3. 배경 음악

**게임플레이 BGM**:
```
"Upbeat retro chiptune background music for Flappy Bird game,
simple and repetitive melody, cheerful and energetic,
60-90 second loopable track, 8-bit style,
moderate tempo (100-120 BPM), C major key,
minimalist instrumentation (lead melody + bass + percussion)"

Style: chiptune, 8-bit, simple
Mood: cheerful, energetic, not distracting
Tempo: 100-120 BPM
Key: C major
Length: 60-90 seconds (seamless loop)
Instruments: square wave lead, triangle bass, noise percussion
Reference: simple mobile game background music
```

**메뉴/대기 음악** (선택):
```
"Calm ambient chiptune for game menu/start screen,
slower tempo (80-100 BPM), gentle and welcoming,
30-45 second loop, 8-bit style, minimal melody,
C major key, very simple and non-intrusive"

Style: chiptune, ambient, minimal
Mood: calm, welcoming
Tempo: 80-100 BPM
```

---

### 4. UI 사운드

**버튼 클릭/탭 사운드**:
```
"8-bit button click sound effect, very short 0.08 second,
simple beep or tap tone, Flappy Bird tap sound,
chiptune synthesizer, crisp and responsive, WAV format"

Parameters:
- Duration: 0.08s
- Pitch: mid-high (E4)
- Style: chiptune, beep/tap
- Tone: crisp, responsive
```

---

## 🎨 추가 에셋 (확장 기능용)

### 새 스킨 변형

**다양한 새 색상**:
```
Pixel art bird variations for Flappy Bird,
same 40x40 size and design, different colors:
1. Red bird (angry bird style)
2. Blue bird (cool theme)
3. Green bird (nature theme)
4. Pink bird (cute theme)

Each with: body color, matching beak, white eyes
Style: pixel art, consistent design across colors
Format: individual PNGs or sprite sheet
```

---

### 파티클 효과

**충돌 파티클**:
```
Pixel art explosion/impact particle sprites,
small 8x8 to 16x16 pixel pieces, yellow/orange/red,
5-8 individual particles for scatter effect,
simple pixel art style, PNG with transparency

Style: pixel art, energetic
Colors: yellow, orange, red, white
Usage: scatter on bird collision
```

**점수 획득 파티클**:
```
Pixel art sparkle/star particles for score gain,
small glitter effect, white/yellow/gold colors,
4-6 frame animation or static sprites,
8x8 pixels per particle, PNG format

Style: pixel art, sparkly
Colors: white, yellow, gold
```

---

### 배경 장식

**구름 스프라이트**:
```
Pixel art cloud sprites for parallax background,
3 size variations: small (40x20), medium (60x30), large (80x40),
fluffy white clouds, simple pixel art style,
transparent background, PNG format

Style: pixel art, fluffy, simple
Colors: white (#FFFFFF), light gray (#E0E0E0)
Quantity: 3-5 different cloud shapes per size
```

**새/별 장식** (배경용):
```
Pixel art small decorative birds flying in background,
tiny silhouettes (16x12 pixels), distant appearance,
simple flapping animation (2 frames),
dark silhouette color, for parallax background layer

Style: pixel art, silhouette, minimal
```

---

## 🛠️ 에셋 생성 도구 추천

### 그래픽
- **Aseprite**: 픽셀 아트 전문 (유료) - 애니메이션 제작에 최적
- **Piskel**: 무료 온라인 픽셀 아트 에디터
- **GraphicsGale**: 픽셀 아트 및 애니메이션 (무료)
- **Midjourney/DALL-E**: AI 이미지 생성 (스타일 참고용)

### 사운드
- **BFXR**: 무료 8-bit 효과음 생성기 (Flappy Bird 스타일에 완벽)
- **ChipTone**: 브라우저 기반 칩튠 효과음 생성
- **Audacity**: 무료 오디오 편집
- **Mubert**: AI 음악 생성

### 음악
- **BeepBox**: 무료 온라인 칩튠 작곡 도구 (매우 간단)
- **FamiTracker**: NES 스타일 칩튠 작곡
- **Bosca Ceoil**: 간단한 루프 음악 제작

---

## 📋 에셋 체크리스트

### 필수 에셋 (현재 게임용)
- [ ] 새 스프라이트 (idle)
- [ ] 파이프 스프라이트 (상단/하단)
- [ ] 땅 스프라이트 (tileable)
- [ ] 배경 이미지
- [ ] 날개짓 사운드
- [ ] 충돌 사운드
- [ ] 점수 획득 사운드
- [ ] 배경 음악 (BGM)

### 확장 에셋 (추가 기능용)
- [ ] 새 날개짓 애니메이션 (3 frames)
- [ ] 새 스킨 변형 (3-4종)
- [ ] 파이프 변형 스타일
- [ ] 구름 스프라이트 (parallax)
- [ ] 충돌 파티클
- [ ] 점수 파티클
- [ ] UI 요소 (버튼, 배너)
- [ ] 탭 사운드

---

## 💡 에셋 최적화 팁

1. **파일 크기**: PNG 최적화 도구 사용 (TinyPNG, OptiPNG)
2. **스프라이트 시트**: 애니메이션은 시트로 통합
3. **오디오 포맷**:
   - 개발: WAV (무손실)
   - 배포: OGG (작은 크기, Flutter 최적화)
4. **해상도**: 픽셀 아트는 정수 배율로 스케일 (2x, 3x, 4x)
5. **색상 팔레트**: 제한된 색상 (8-16 colors) 사용으로 일관성 유지
6. **사운드 길이**: 효과음은 0.5초 이하로 짧게 유지

---

## 🎨 Flappy Bird 스타일 가이드

### 색상 팔레트
```
Sky: #87CEEB (Sky Blue)
Bird: #FFFF00 (Yellow), #FFA500 (Orange beak)
Pipe: #00AA00 (Green), #00CC00 (Light Green), #008800 (Dark Green)
Ground: #8b4513 (Saddle Brown), #228B22 (Forest Green), #654321 (Dark Brown)
UI: #FFFFFF (White), #000000 (Black), #FF0000 (Red for game over)
```

### 디자인 원칙
- **단순함**: 최소한의 디테일, 명확한 실루엣
- **고대비**: 배경과 오브젝트 명확한 구분
- **친근함**: 둥근 형태, 밝은 색상
- **가독성**: UI 텍스트는 굵고 그림자 있음

---

**이 프롬프트들을 AI 에셋 생성 도구에 복사하여 사용하세요!**
