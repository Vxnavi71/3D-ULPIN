import cv2, numpy as np, os, math, time, subprocess, imageio_ffmpeg
from PIL import Image, ImageDraw, ImageFont

ffmpeg_exe = imageio_ffmpeg.get_ffmpeg_exe()

WIDTH = 1920
HEIGHT = 1080
FPS = 30
TOTAL_SECONDS = 180.0
TOTAL_FRAMES = int(TOTAL_SECONDS * FPS)

FONT_BOLD = r'C:\Windows\Fonts\segoeuib.ttf'
FONT_REG = r'C:\Windows\Fonts\segoeui.ttf'
FONT_MONO = r'C:\Windows\Fonts\consola.ttf'

f_h1 = ImageFont.truetype(FONT_BOLD, 48)
f_h2 = ImageFont.truetype(FONT_BOLD, 30)
f_body = ImageFont.truetype(FONT_REG, 18)
f_mono = ImageFont.truetype(FONT_MONO, 16)
f_small = ImageFont.truetype(FONT_REG, 14)
f_badge = ImageFont.truetype(FONT_BOLD, 13)

def draw_location_target(draw, cx, cy, r=26, fill=(34, 211, 238), width=3):
    draw.ellipse([(cx - r, cy - r), (cx + r, cy + r)], outline=fill, width=width)
    tick = max(int(r * 0.45), 4)
    draw.line([(cx, cy - r - tick), (cx, cy - r + 1)], fill=fill, width=width)
    draw.line([(cx, cy + r - 1), (cx, cy + r + tick)], fill=fill, width=width)
    draw.line([(cx - r - tick, cy), (cx - r + 1, cy)], fill=fill, width=width)
    draw.line([(cx + r - 1, cy), (cx + r + tick, cy)], fill=fill, width=width)
    dot_r = max(int(r * 0.22), 3)
    draw.ellipse([(cx - dot_r, cy - dot_r), (cx + dot_r, cy + dot_r)], fill=fill)

def draw_cursor(draw, cx, cy, fill=(255, 255, 255, 255), outline=(15, 23, 42, 255)):
    cursor_pts = [
        (cx, cy),
        (cx, cy + 24),
        (cx + 6, cy + 19),
        (cx + 13, cy + 30),
        (cx + 17, cy + 28),
        (cx + 10, cy + 17),
        (cx + 18, cy + 17)
    ]
    draw.polygon(cursor_pts, fill=fill, outline=outline)

def draw_click_ripple(draw, cx, cy, progress, color=(34, 211, 238)):
    r = int(5 + progress * 26)
    alpha = int(220 * (1.0 - progress))
    if alpha > 0:
        draw.ellipse([(cx - r, cy - r), (cx + r, cy + r)], outline=(color[0], color[1], color[2], alpha), width=3)

SCHEDULE = [
    {
        'step': 1, 'start': 0.0, 'dur': 10.5,
        'shot': 'video_build/shots/step_01.png',
        'btn_click': (960, 685), 'click_rel': 9.5,
        'cursor_kfs': [(0.0, (960, 540)), (4.0, (960, 520)), (7.0, (960, 520)), (9.2, (960, 685)), (10.0, (960, 685))]
    },
    {
        'step': 2, 'start': 10.5, 'dur': 10.0,
        'shot': 'video_build/shots/step_02.png',
        'btn_click': (960, 670), 'click_rel': 8.9,
        'cursor_kfs': [(0.0, (960, 685)), (2.0, (960, 420)), (4.5, (960, 535)), (7.2, (960, 535)), (8.8, (960, 670)), (9.5, (960, 670))]
    },
    {
        'step': 3, 'start': 20.5, 'dur': 11.0,
        'shot': 'video_build/shots/step_03.png',
        'btn_click': (1805, 1042), 'click_rel': 9.9,
        'cursor_kfs': [(0.0, (960, 670)), (2.2, (520, 240)), (4.5, (850, 240)), (6.5, (1180, 240)), (8.0, (640, 520)), (9.8, (1805, 1042)), (10.5, (1805, 1042))]
    },
    {
        'step': 4, 'start': 31.5, 'dur': 10.5,
        'shot': 'video_build/shots/step_04.png',
        'btn_click': (1805, 1042), 'click_rel': 9.5,
        'cursor_kfs': [(0.0, (1805, 1042)), (2.2, (750, 320)), (5.0, (750, 480)), (7.5, (750, 580)), (9.4, (1805, 1042)), (10.0, (1805, 1042))]
    },
    {
        'step': 5, 'start': 42.0, 'dur': 10.5,
        'shot': 'video_build/shots/step_05.png',
        'btn_click': (1805, 1042), 'click_rel': 9.5,
        'cursor_kfs': [(0.0, (1805, 1042)), (2.5, (880, 460)), (5.5, (940, 520)), (7.5, (860, 460)), (9.4, (1805, 1042)), (10.0, (1805, 1042))]
    },
    {
        'step': 6, 'start': 52.5, 'dur': 10.5,
        'shot': 'video_build/shots/step_06.png',
        'btn_click': (1805, 1042), 'click_rel': 9.5,
        'cursor_kfs': [(0.0, (1805, 1042)), (2.5, (900, 380)), (5.0, (900, 480)), (7.5, (900, 580)), (9.4, (1805, 1042)), (10.0, (1805, 1042))]
    },
    {
        'step': 7, 'start': 63.0, 'dur': 10.5,
        'shot': 'video_build/shots/step_07.png',
        'btn_click': (1805, 1042), 'click_rel': 9.5,
        'cursor_kfs': [(0.0, (1805, 1042)), (2.5, (920, 460)), (5.5, (960, 520)), (7.5, (920, 460)), (9.4, (1805, 1042)), (10.0, (1805, 1042))]
    },
    {
        'step': 8, 'start': 73.5, 'dur': 11.0,
        'shot': 'video_build/shots/step_08.png',
        'btn_click': (1805, 1042), 'click_rel': 9.9,
        'cursor_kfs': [(0.0, (1805, 1042)), (2.5, (600, 320)), (5.5, (750, 360)), (7.8, (960, 480)), (9.8, (1805, 1042)), (10.5, (1805, 1042))]
    },
    {
        'step': 9, 'start': 84.5, 'dur': 11.0,
        'shot': 'video_build/shots/step_09.png',
        'btn_click': (1805, 1042), 'click_rel': 9.9,
        'cursor_kfs': [(0.0, (1805, 1042)), (2.5, (650, 240)), (5.5, (850, 420)), (7.8, (950, 420)), (9.8, (1805, 1042)), (10.5, (1805, 1042))]
    },
    {
        'step': 10, 'start': 95.5, 'dur': 11.0,
        'shot': 'video_build/shots/step_10.png',
        'btn_click': (1805, 1042), 'click_rel': 9.9,
        'cursor_kfs': [(0.0, (1805, 1042)), (2.5, (880, 460)), (5.5, (920, 520)), (7.8, (880, 460)), (9.8, (1805, 1042)), (10.5, (1805, 1042))]
    },
    {
        'step': 11, 'start': 106.5, 'dur': 10.5,
        'shot': 'video_build/shots/step_11.png',
        'btn_click': (1805, 1042), 'click_rel': 9.5,
        'cursor_kfs': [(0.0, (1805, 1042)), (2.5, (960, 480)), (5.5, (980, 540)), (7.5, (960, 480)), (9.4, (1805, 1042)), (10.0, (1805, 1042))]
    },
    {
        'step': 12, 'start': 117.0, 'dur': 11.0,
        'shot': 'video_build/shots/step_12.png',
        'btn_click': (1805, 1042), 'click_rel': 9.9,
        'cursor_kfs': [(0.0, (1805, 1042)), (2.5, (880, 480)), (5.5, (920, 520)), (7.8, (880, 480)), (9.8, (1805, 1042)), (10.5, (1805, 1042))]
    },
    {
        'step': 13, 'start': 128.0, 'dur': 10.5,
        'shot': 'video_build/shots/step_13.png',
        'btn_click': (1805, 1042), 'click_rel': 9.5,
        'cursor_kfs': [(0.0, (1805, 1042)), (2.5, (920, 460)), (5.5, (960, 520)), (7.5, (920, 460)), (9.4, (1805, 1042)), (10.0, (1805, 1042))]
    },
    {
        'step': 14, 'start': 138.5, 'dur': 18.5,
        'shot': 'video_build/shots/step_14.png',
        'btn_click': (1805, 1042), 'click_rel': 17.3,
        'cursor_kfs': [
            (0.0, (1805, 1042)),
            (2.5, (640, 360)),
            (5.0, (1380, 360)),
            (7.5, (1380, 410)),
            (10.0, (1380, 460)),
            (12.5, (1380, 510)),
            (15.0, (1380, 510)),
            (17.1, (1805, 1042)),
            (17.8, (1805, 1042))
        ]
    },
    {
        'step': 15, 'start': 157.0, 'dur': 23.0,
        'shot': 'video_build/shots/step_15.png',
        'btn_click': (400, 361), 'click_rel': 2.8,
        'cursor_kfs': [
            (0.0, (1805, 1042)),
            (2.6, (400, 361)),
            (3.4, (400, 361)),
            (5.5, (380, 767)),
            (8.0, (380, 767))
        ]
    }
]

shots = {}
for s in SCHEDULE:
    num = s['step']
    path = s['shot']
    if os.path.exists(path):
        img = cv2.imread(path)
        if img.shape[0] != HEIGHT or img.shape[1] != WIDTH:
            img = cv2.resize(img, (WIDTH, HEIGHT))
        shots[num] = img
    else:
        shots[num] = np.zeros((HEIGHT, WIDTH, 3), dtype=np.uint8)

shot_15_before = cv2.imread('video_build/shots/step_15_before.png')
shot_15_after = cv2.imread('video_build/shots/step_15_after.png')
if shot_15_before is not None and (shot_15_before.shape[0] != HEIGHT or shot_15_before.shape[1] != WIDTH):
    shot_15_before = cv2.resize(shot_15_before, (WIDTH, HEIGHT))
if shot_15_after is not None and (shot_15_after.shape[0] != HEIGHT or shot_15_after.shape[1] != WIDTH):
    shot_15_after = cv2.resize(shot_15_after, (WIDTH, HEIGHT))

def ease_in_out(t):
    return t * t * (3.0 - 2.0 * t)

def interpolate_pos(kfs, t_rel):
    if not kfs:
        return (960, 540)
    if t_rel <= kfs[0][0]:
        return kfs[0][1]
    if t_rel >= kfs[-1][0]:
        return kfs[-1][1]
    for i in range(len(kfs) - 1):
        t0, p0 = kfs[i]
        t1, p1 = kfs[i + 1]
        if t0 <= t_rel <= t1:
            dt = t1 - t0
            if dt <= 0.0001:
                return p0
            s = ease_in_out((t_rel - t0) / dt)
            x = int(p0[0] + (p1[0] - p0[0]) * s)
            y = int(p0[1] + (p1[1] - p0[1]) * s)
            return (x, y)
    return kfs[-1][1]

def generate_frame(sec):
    active_idx = 0
    for idx, s in enumerate(SCHEDULE):
        if s['start'] <= sec < s['start'] + s['dur']:
            active_idx = idx
            break
        elif sec >= SCHEDULE[-1]['start']:
            active_idx = len(SCHEDULE) - 1

    active_step = SCHEDULE[active_idx]
    step_num = active_step['step']
    step_start = active_step['start']
    step_dur = active_step['dur']
    t_rel = sec - step_start

    if step_num == 15:
        if sec < 159.8:
            base_frame = shot_15_before.copy()
        elif sec < 160.1:
            t_sw = (sec - 159.8) / 0.3
            base_frame = cv2.addWeighted(shot_15_before, 1.0 - t_sw, shot_15_after, t_sw, 0.0)
        else:
            base_frame = shot_15_after.copy()
    else:
        curr_shot = shots.get(step_num, shots[1])
        next_step_num = step_num + 1 if (step_num < 15) else 15
        next_shot = shots.get(next_step_num, curr_shot)
        
        trans_duration = 0.35
        t_trans_start = step_dur - trans_duration
        if t_rel >= t_trans_start:
            alpha = min(max((t_rel - t_trans_start) / trans_duration, 0.0), 1.0)
            base_frame = cv2.addWeighted(curr_shot, 1.0 - alpha, next_shot, alpha, 0.0)
        else:
            base_frame = curr_shot.copy()

    pil_img = Image.fromarray(cv2.cvtColor(base_frame, cv2.COLOR_BGR2RGB))
    draw = ImageDraw.Draw(pil_img, 'RGBA')

    if sec < 176.5:
        cur_pos = interpolate_pos(active_step['cursor_kfs'], t_rel)
        btn_pos = active_step['btn_click']
        click_time = active_step['click_rel']
        
        if click_time <= t_rel < click_time + 0.6:
            r_prog = (t_rel - click_time) / 0.6
            ripple_color = (34, 211, 238) if step_num in [1, 2, 15] else (59, 130, 246)
            draw_click_ripple(draw, btn_pos[0], btn_pos[1], r_prog, color=ripple_color)

        if step_num == 15 and sec >= 164.5:
            fade_prog = min((sec - 164.5) / 1.5, 1.0)
            c_alpha = int(255 * (1.0 - fade_prog))
            if c_alpha > 10:
                draw_cursor(draw, cur_pos[0], cur_pos[1], fill=(255, 255, 255, c_alpha), outline=(15, 23, 42, c_alpha))
        else:
            draw_cursor(draw, cur_pos[0], cur_pos[1])

    else:
        fade_in = min((sec - 176.5) / 0.5, 1.0)
        draw.rectangle([(0, 0), (WIDTH, HEIGHT)], fill=(7, 9, 13, int(255 * fade_in)))
        if fade_in > 0.4:
            draw_location_target(draw, WIDTH // 2, HEIGHT // 2 - 100, r=32, fill=(34, 211, 238), width=4)
            draw.text((WIDTH // 2 - 150, HEIGHT // 2 - 40), 'LUNARA', fill=(248, 250, 252), font=f_h1)
            statement = '"Enabling 3D Digital Property Intelligence"'
            draw.text((WIDTH // 2 - 310, HEIGHT // 2 + 50), statement, fill=(34, 211, 238), font=f_h2)
            draw.text((WIDTH // 2 - 350, HEIGHT // 2 + 115), 'Smart India Hackathon 2026 • Problem Statement PS-26011 • Team 168736', fill=(148, 163, 184), font=f_body)

    return pil_img

def render_all_frames():
    final_output = 'lunara_3d_demonstration_video.mp4'
    build_output = 'video_build/lunara_3d_demonstration_video.mp4'

    writer = imageio_ffmpeg.write_frames(
        build_output,
        (WIDTH, HEIGHT),
        fps=FPS,
        quality=8,
        codec='libx264',
        pix_fmt_in='rgb24',
        pix_fmt_out='yuv420p',
        macro_block_size=1,
        audio_path='video_build/lunara_master_audio.wav',
        output_params=['-preset', 'fast']
    )
    writer.send(None)

    start_time = time.time()
    print('Rendering 5400 frames with prototype fidelity and imageio_ffmpeg...')

    for frame_idx in range(TOTAL_FRAMES):
        sec = frame_idx / FPS
        pil_img = generate_frame(sec)
        writer.send(np.ascontiguousarray(np.array(pil_img, dtype=np.uint8)))

        if frame_idx % 300 == 0:
            elapsed = time.time() - start_time
            fps_curr = (frame_idx + 1) / (elapsed + 0.001)
            print(f'Frame {frame_idx}/{TOTAL_FRAMES} ({frame_idx/TOTAL_FRAMES*100:.1f}%) - {fps_curr:.1f} fps')

    writer.close()

    if os.path.exists(build_output):
        import shutil
        shutil.copy(build_output, final_output)
        print(f'Copied build output to root: {final_output}')

    print('Video rendering and audio muxing complete in', time.time() - start_time, 'seconds!')
    print('FINAL DEMONSTRATION VIDEO COMPLETE:', build_output)
    if os.path.exists(build_output):
        print('Size:', os.path.getsize(build_output), 'bytes')

if __name__ == '__main__':
    render_all_frames()
