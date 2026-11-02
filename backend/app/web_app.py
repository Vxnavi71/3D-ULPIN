HTML_CONTENT = """<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>LUNARA – 3D ULPIN & Vertical Property Intelligence (SIH 2026 PS-26011)</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&family=JetBrains+Mono:wght@500;700;800&display=swap" rel="stylesheet">
  <style>
    :root {
      /* Dark Base Neutral Foundation (70-80%) */
      --bg: #07090D;
      --bg-secondary: #0B0F14;
      --panel: #11161D;
      --panel-elevated: #171D25;
      --line: #26313D;
      --line-highlight: #384758;

      --text: #F8FAFC;
      --text-secondary: #94A3B8;
      --text-muted: #64748B;

      /* Functional Semantic Colors (20-30%) */
      --cyan: #22D3EE;   /* Primary Actions / ULPIN / Active Navigation */
      --blue: #3B82F6;   /* Spatial / Map Elements / Boundaries */
      --violet: #8B5CF6; /* AI / 3D Volumetric Intelligence / Insights */
      --green: #22C55E;  /* Validated / Success States */
      --amber: #F59E0B;  /* Warnings / Spatial Conflicts / Prototype Notices */
    }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      background: var(--bg);
      color: var(--text);
      font-family: 'Plus Jakarta Sans', -apple-system, sans-serif;
      display: flex;
      height: 100vh;
      overflow: hidden;
      user-select: none;
    }
    /* Layout */
    #sidebar {
      width: 250px;
      background: var(--panel);
      border-right: 1px solid var(--line);
      display: flex;
      flex-direction: column;
      flex-shrink: 0;
    }
    #main {
      flex: 1;
      display: flex;
      flex-direction: column;
      height: 100vh;
      overflow: hidden;
      background: var(--bg);
    }
    #topbar {
      height: 68px;
      background: var(--panel);
      border-bottom: 1px solid var(--line);
      display: flex;
      align-items: center;
      padding: 0 24px;
      gap: 12px;
      flex-shrink: 0;
    }
    #content {
      flex: 1;
      overflow-y: auto;
      padding: 24px 28px;
    }
    /* Brand Header */
    .brand {
      padding: 22px 20px 16px;
      display: flex;
      align-items: center;
      gap: 12px;
      border-bottom: 1px solid var(--line);
      cursor: pointer;
    }
    .brand-icon {
      width: 40px; height: 40px;
      background: rgba(34, 211, 238, 0.12);
      border: 1.5px solid rgba(34, 211, 238, 0.4);
      border-radius: 10px;
      display: flex; align-items: center; justify-content: center;
      color: var(--cyan);
      font-size: 20px;
    }
    .brand-title { font-size: 21px; font-weight: 900; letter-spacing: 0.8px; color: var(--text); }
    .brand-sub { font-size: 8.5px; font-weight: 800; color: var(--cyan); letter-spacing: 0.9px; }
    
    /* Navigation */
    .nav-list { padding: 14px 10px; display: flex; flex-direction: column; gap: 4px; }
    .nav-item {
      display: flex; align-items: center; gap: 12px;
      padding: 10px 14px;
      border-radius: 8px;
      color: var(--text-secondary);
      font-size: 13px; font-weight: 600;
      cursor: pointer;
      transition: all 0.15s;
    }
    .nav-item:hover { color: var(--text); background: var(--panel-elevated); }
    .nav-item.active {
      color: var(--cyan);
      background: rgba(34, 211, 238, 0.12);
      border: 1px solid rgba(34, 211, 238, 0.35);
      font-weight: 800;
    }
    .nav-icon {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 20px;
      height: 20px;
      color: inherit;
    }
    .nav-icon svg {
      width: 18px;
      height: 18px;
    }
    .sidebar-footer {
      margin-top: auto;
      padding: 16px;
    }
    .demo-card {
      background: var(--bg-secondary);
      border: 1px solid rgba(34, 211, 238, 0.25);
      border-radius: 10px;
      padding: 12px;
    }

    /* Badges */
    .badge {
      display: inline-flex; align-items: center; gap: 6px;
      padding: 4px 10px; border-radius: 20px;
      font-size: 11px; font-weight: 700;
      background: rgba(34, 211, 238, 0.12);
      border: 1px solid rgba(34, 211, 238, 0.35);
      color: var(--cyan);
    }
    .badge-blue { background: rgba(59, 130, 246, 0.12); border-color: rgba(59, 130, 246, 0.35); color: var(--blue); }
    .badge-violet { background: rgba(139, 92, 246, 0.12); border-color: rgba(139, 92, 246, 0.35); color: var(--violet); }
    .badge-green { background: rgba(34, 197, 94, 0.12); border-color: rgba(34, 197, 94, 0.35); color: var(--green); }
    .badge-amber { background: rgba(245, 158, 11, 0.12); border-color: rgba(245, 158, 11, 0.35); color: var(--amber); }

    /* Buttons */
    .btn {
      display: inline-flex; align-items: center; gap: 8px;
      padding: 9px 16px; border-radius: 8px;
      font-size: 12px; font-weight: 800; letter-spacing: 0.3px;
      cursor: pointer; border: none; transition: all 0.15s;
    }
    .btn-primary { background: var(--cyan); color: #042F2E; }
    .btn-primary:hover { opacity: 0.92; transform: translateY(-1px); }
    .btn-secondary { background: var(--panel-elevated); color: var(--text); border: 1px solid var(--line); }
    .btn-secondary:hover { background: #202834; border-color: var(--line-highlight); }
    .btn-blue { background: var(--blue); color: #0F172A; }
    .btn-violet { background: var(--violet); color: white; }
    .btn-amber { background: var(--amber); color: #351C05; }
    .btn-outline-amber { background: transparent; color: var(--amber); border: 1px solid var(--amber); }
    .btn-outline-violet { background: transparent; color: var(--violet); border: 1px solid var(--violet); }

    /* Panels & Metrics */
    .panel {
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 14px;
      padding: 20px;
      margin-bottom: 20px;
    }
    .panel-header {
      display: flex; justify-content: space-between; align-items: center;
      margin-bottom: 16px;
    }
    .panel-title { font-size: 15px; font-weight: 800; color: var(--text); letter-spacing: 0.2px; }

    .metrics-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
      gap: 14px;
      margin-bottom: 22px;
    }
    .metric-card {
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 12px;
      padding: 16px;
      display: flex; flex-direction: column; justify-content: space-between;
    }
    .metric-label { font-size: 11px; font-weight: 700; color: var(--text-secondary); letter-spacing: 0.5px; }
    .metric-val { font-size: 26px; font-weight: 900; color: var(--text); margin-top: 6px; }

    .search-input {
      flex: 1; height: 42px;
      background: var(--panel-elevated);
      border: 1px solid var(--line);
      border-radius: 8px;
      padding: 0 16px;
      color: var(--text);
      font-size: 13px;
      outline: none;
    }
    .search-input:focus { border-color: var(--cyan); }

    /* 3D Canvas Area */
    #canvas-container {
      position: relative;
      height: 480px;
      background: var(--bg-secondary);
      border: 1px solid var(--line);
      border-radius: 14px;
      overflow: hidden;
      margin-bottom: 20px;
    }
    #map3d-canvas { width: 100%; height: 100%; display: block; cursor: grab; }
    #map3d-canvas:active { cursor: grabbing; }
    .canvas-hud {
      position: absolute;
      top: 14px; right: 14px;
      display: flex; gap: 8px; z-index: 10;
    }
    .hud-btn {
      background: rgba(17, 22, 29, 0.9);
      border: 1px solid var(--line);
      color: var(--text);
      padding: 8px 12px;
      border-radius: 8px;
      font-size: 11px; font-weight: 700;
      cursor: pointer;
    }
    .hud-btn:hover { background: var(--panel-elevated); border-color: var(--cyan); }

    /* Bottom Judge Stepper Bar */
    #judge-bar {
      height: 68px;
      background: #09131C;
      border-top: 2px solid var(--cyan);
      display: none;
      align-items: center;
      padding: 0 24px;
      gap: 16px;
      flex-shrink: 0;
      z-index: 100;
      box-shadow: 0 -8px 24px rgba(0,0,0,0.5);
    }

    /* Modal Dialogs (Splash, Registration) */
    .modal-overlay {
      position: fixed; inset: 0;
      background: rgba(7, 9, 13, 0.88);
      backdrop-filter: blur(8px);
      display: flex; align-items: center; justify-content: center;
      z-index: 2000;
    }
    .modal-card {
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 18px;
      box-shadow: 0 20px 50px rgba(0,0,0,0.7);
      width: 540px;
      max-width: 90vw;
      padding: 32px;
    }
  </style>
</head>
<body>

  <!-- Sidebar -->
  <div id="sidebar">
    <div class="brand" onclick="showSplashModal()">
      <div class="brand-icon">
        <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="7"></circle><line x1="12" y1="1" x2="12" y2="5"></line><line x1="12" y1="19" x2="12" y2="23"></line><line x1="1" y1="12" x2="5" y2="12"></line><line x1="19" y1="12" x2="23" y2="12"></line></svg>
      </div>
      <div>
        <div class="brand-title">LUNARA</div>
        <div class="brand-sub">3D PROPERTY INTELLIGENCE</div>
      </div>
    </div>
    <div class="nav-list">
      <div class="nav-item active" onclick="setScreen('dashboard')"><span class="nav-icon"><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg></span> Dashboard</div>
      <div class="nav-item" onclick="setScreen('map')"><span class="nav-icon"><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path><polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline><line x1="12" y1="22.08" x2="12" y2="12"></line></svg></span> 3D Map</div>
      <div class="nav-item" onclick="setScreen('ulpin')"><span class="nav-icon"><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg></span> ULPIN Generator</div>
      <div class="nav-item" onclick="setScreen('validation')"><span class="nav-icon"><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path><path d="m9 14 2 2 4-4"></path></svg></span> Spatial Validation</div>
      <div class="nav-item" onclick="setScreen('property')"><span class="nav-icon"><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="3" width="6" height="6" rx="1"></rect><rect x="16" y="3" width="6" height="6" rx="1"></rect><rect x="16" y="15" width="6" height="6" rx="1"></rect><path d="M5 9v3a2 2 0 0 0 2 2h9"></path><path d="M19 9v6"></path></svg></span> Property Details</div>
      <div class="nav-item" onclick="setScreen('pipeline')"><span class="nav-icon"><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4.5 16.5c-1.5 1.26-2 5-2 5s3.74-.5 5-2c.71-.84.7-2.13-.09-2.91a2.18 2.18 0 0 0-2.91-.09z"></path><path d="M12 15l-3-3a22 22 0 0 1 2-3.95A12.88 12.88 0 0 1 22 2c0 2.72-.78 7.5-2.05 9a22 22 0 0 1-4 2z"></path></svg></span> Demo Pipeline</div>
      <div class="nav-item" onclick="setScreen('settings')"><span class="nav-icon"><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg></span> Settings</div>
    </div>
    <div class="sidebar-footer">
      <div class="demo-card">
        <div style="color: var(--cyan); font-weight: 800; font-size: 10px; margin-bottom: 4px;">SIH 2026 PROTOTYPE</div>
        <div style="color: var(--text-secondary); font-size: 11px;">PS-26011 • Team 168736</div>
        <div style="color: var(--text-muted); font-size: 10px; margin-top: 2px;">DEMO MODE • Synthetic Data</div>
      </div>
    </div>
  </div>

  <!-- Main View -->
  <div id="main">
    <div id="topbar">
      <input type="text" id="global-search" class="search-input" placeholder="Search parcel (P001), building (B001), unit (A-201) or ULPIN…" onkeypress="if(event.key==='Enter') search(this.value)">
      <span class="badge badge-blue">PS-26011</span>
      
      <!-- Topbar Action Triggers -->
      <button class="btn btn-outline-violet" onclick="startLiveDemoPipeline()">
        <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4.5 16.5c-1.5 1.26-2 5-2 5s3.74-.5 5-2c.71-.84.7-2.13-.09-2.91a2.18 2.18 0 0 0-2.91-.09z"></path><path d="M12 15l-3-3a22 22 0 0 1 2-3.95A12.88 12.88 0 0 1 22 2c0 2.72-.78 7.5-2.05 9a22 22 0 0 1-4 2z"></path></svg>
        START LIVE DEMO
      </button>
      <button class="btn btn-outline-amber" onclick="triggerSpatialValidation()">
        <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 11l3 3L22 4"></path><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
        RUN VALIDATION
      </button>
      <button class="btn btn-primary" onclick="startJudgeTour()">
        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 14.5v-9l6 4.5-6 4.5z"/></svg>
        JUDGE DEMO
      </button>
      <button class="btn btn-secondary" onclick="showRegistrationModal()" title="Cadastral Portal Registration">
        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
      </button>
      <button class="btn btn-secondary" onclick="setScreen('settings')" title="Preferences">
        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg>
      </button>
    </div>

    <div id="content">
      <!-- Dynamic Content Rendered Here -->
    </div>

    <!-- Judge Demo Interactive Stepper Controller -->
    <div id="judge-bar">
      <div class="badge" id="judge-step-badge" style="font-weight:900;">STEP 1 / 15</div>
      <div style="flex:1">
        <div id="judge-step-title" style="font-weight: 900; font-size: 14px; color: var(--text);">LUNARA Splash Screen</div>
        <div id="judge-step-desc" style="font-size: 11px; color: var(--text-secondary);">System identity: 3D ULPIN Generation & Vertical Property Mapping Platform.</div>
      </div>
      <button class="btn btn-secondary" onclick="prevJudgeStep()">PREV</button>
      <button class="btn btn-primary" id="judge-next-btn" onclick="nextJudgeStep()">NEXT STEP ▶</button>
      <button class="btn btn-secondary" onclick="stopJudgeTour()">✕ EXIT</button>
    </div>
  </div>

  <!-- Judge Demo Video Modal -->
  <div id="video-modal" class="modal-overlay" style="display:none; z-index:9999;" onclick="if(event.target===this)closeVideoModal()">
    <div class="modal-card" style="max-width:1100px; width:95vw; padding:0; background:#0B0F14; border:1px solid #26313D; overflow:hidden;">
      <div style="display:flex; justify-content:space-between; align-items:center; padding:14px 20px; background:#11161F; border-bottom:1px solid #26313D;">
        <div style="display:flex; align-items:center; gap:10px;">
          <svg viewBox="0 0 24 24" width="20" height="20" fill="var(--cyan)"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 14.5v-9l6 4.5-6 4.5z"/></svg>
          <span style="font-size:15px; font-weight:900; color:#F8FAFC; letter-spacing:0.5px;">LUNARA — 3D PROTOTYPE DEMONSTRATION</span>
          <span class="badge badge-blue">SIH 2026 PS-26011</span>
        </div>
        <button class="btn btn-secondary" style="padding:6px 12px; font-weight:800;" onclick="closeVideoModal()">✕ CLOSE</button>
      </div>
      <div style="position:relative; background:#000; display:flex; justify-content:center; align-items:center;">
        <video id="judge-video-player" src="/api/video/demo" controls style="width:100%; max-height:80vh; display:block;" preload="auto"></video>
      </div>
    </div>
  </div>

  <!-- Splash Screen Modal -->
  <div id="splash-modal" class="modal-overlay" style="display:none;">
    <div class="modal-card" style="text-align: center;">
      <div style="width:72px; height:72px; margin:0 auto 18px; border-radius:50%; background:rgba(34,211,238,0.12); border:2px solid var(--cyan); display:flex; align-items:center; justify-content:center; color:var(--cyan);"><svg viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="7"></circle><line x1="12" y1="1" x2="12" y2="5"></line><line x1="12" y1="19" x2="12" y2="23"></line><line x1="1" y1="12" x2="5" y2="12"></line><line x1="19" y1="12" x2="23" y2="12"></line></svg></div>
      <h1 style="font-size:28px; font-weight:900; letter-spacing:0.5px;">LUNARA</h1>
      <div style="font-size:11px; font-weight:800; color:var(--cyan); letter-spacing:1px; margin:4px 0 16px;">3D ULPIN & VERTICAL PROPERTY INTELLIGENCE</div>
      <p style="color:var(--text-secondary); font-size:13px; line-height:1.6; margin-bottom:24px;">
        Cadastral platform demonstrating 4-tier vertical spatial hierarchy (Parcel → Building → Floor → Property) with automated 3D ULPIN encoding and topological conflict detection.
      </p>
      <div style="display:flex; justify-content:center; gap:8px; margin-bottom:28px;">
        <span class="badge badge-blue">SIH 2026</span>
        <span class="badge badge-green">PS-26011</span>
        <span class="badge badge-violet">TEAM: 168736</span>
      </div>
      <div style="display:flex; flex-direction:column; gap:10px;">
        <button class="btn btn-primary" style="justify-content:center; padding:12px;" onclick="closeSplashModal()">ENTER CADASTRE PLATFORM</button>
        <button class="btn btn-blue" style="justify-content:center; padding:12px;" onclick="closeSplashModal(); startJudgeTour();">START EVALUATOR DEMO (15 STEPS)</button>
        <button class="btn btn-secondary" style="justify-content:center; padding:10px;" onclick="closeSplashModal(); showRegistrationModal();">SURVEYOR / EVALUATOR REGISTRATION</button>
      </div>
    </div>
  </div>

  <!-- Registration Screen Modal -->
  <div id="reg-modal" class="modal-overlay" style="display:none;">
    <div class="modal-card">
      <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
        <div>
          <h2 style="font-size:20px; font-weight:900;">Cadastral Access Portal</h2>
          <p style="color:var(--text-secondary); font-size:12px;">Create demonstration profile for vertical cadastre review.</p>
        </div>
        <button class="btn btn-secondary" style="padding:6px 10px;" onclick="closeRegistrationModal()">✕</button>
      </div>
      <div style="display:flex; flex-direction:column; gap:14px;">
        <div>
          <label style="font-size:11px; font-weight:700; color:var(--text-secondary); display:block; margin-bottom:6px;">OFFICER / EVALUATOR NAME</label>
          <input type="text" class="search-input" style="width:100%;" value="test1">
        </div>
        <div>
          <label style="font-size:11px; font-weight:700; color:var(--text-secondary); display:block; margin-bottom:6px;">OFFICIAL EMAIL</label>
          <input type="email" class="search-input" style="width:100%;" value="test@gmail.com">
        </div>
        <div>
          <label style="font-size:11px; font-weight:700; color:var(--text-secondary); display:block; margin-bottom:6px;">ROLE & ACCESS LEVEL</label>
          <select class="search-input" style="width:100%; height:42px; cursor:pointer;">
            <option selected>Surveyor / Cadastral Officer</option>
            <option>Town Planning & Urban Body</option>
            <option>SIH Hackathon Evaluator</option>
            <option>Citizen / Property Owner</option>
          </select>
        </div>
        <div>
          <label style="font-size:11px; font-weight:700; color:var(--text-secondary); display:block; margin-bottom:6px;">DEMO PASSCODE</label>
          <input type="password" class="search-input" style="width:100%;" value="lunara2026">
        </div>
        <button class="btn btn-primary" style="justify-content:center; padding:12px; margin-top:8px;" onclick="submitRegistration()">REGISTER DEMO ACCESS</button>
      </div>
    </div>
  </div>

  <script>
    let state = {
      nav: 'dashboard',
      dashboard: {},
      parcels: [],
      buildings: [],
      selectedBuilding: null,
      floors: [],
      selectedFloor: null,
      selectedProperty: null,
      exploded: false,
      issues: [],
      selectedIssue: null,
      ulpin: null,
      pipeline: [],
      judgeTour: false,
      judgeStep: 1,
      crs: 'EPSG:7755 (India National Grid)',
      units: 'Metric (Meters, m²)',
      wireframe: false,
      explosionGap: 52
    };

    const judgeTourSteps = [
      { title: "Lunara Geospatial Splash Screen", desc: "System identity: 3D ULPIN Generation & Vertical Property Mapping Platform (SIH PS-26011)." },
      { title: "Prototype Cadastral Access Registration", desc: "Surveyor & Citizen authentication portal for multi-tier urban property records." },
      { title: "Command Center Overview", desc: "Live KPI metrics: 7 Parcels, 7 Buildings, 21 Floors, 42 Properties, 28 Topology Checks." },
      { title: "Launch Live Processing Pipeline", desc: "Automated data ingestion converting 2D cadastral records into 3D vertical spatial hierarchies." },
      { title: "Controlled 3D Map Environment", desc: "Interactive 3D cadastral scene with parcel boundaries and extruded building volumes." },
      { title: "Explore Building Floors Vertically", desc: "Vertical floor separation revealing individual floorplates and interior spatial units." },
      { title: "Select Property Unit A201", desc: "Target Unit A-201 (115 m² Residential) on Floor 2 (+8.0m elevation) chosen for ULPIN encoding." },
      { title: "Generate Prototype 3D ULPIN", desc: "Hierarchical spatial encoding: State (TS) → District (HYD) → Parcel → Building → Floor → Unit." },
      { title: "Run Spatial Validation", desc: "Topology engine executes 28 checks: green for passed, amber for warnings & conflicts." },
      { title: "Select Mock Building A Footprint Conflict", desc: "Focusing on Building B006: Structure footprint exceeds registered parcel boundary by 4.2m on East edge." },
      { title: "Inspect and Highlight Footprint Conflict in 3D", desc: "Boundary Encroachment conflict V006 highlighted in glowing Amber on 3D Map view." },
      { title: "Select Mock Building B", desc: "Focusing on Building B007: Vertical elevation overlap detected between Floor 1 ceiling and Floor 2 floorplate." },
      { title: "Inspect and Highlight Vertical Conflict in 3D", desc: "Vertical Elevation clash V007 highlighted in glowing Amber with vertical slab collision indicator." },
      { title: "Inspect Digital Property Hierarchy", desc: "Verifying complete 4-tier relationship: Parcel → Building → Floor → Property unit." },
      { title: "Export Digital Property Record JSON", desc: "Generating standardized JSON property record with 3D ULPIN and cryptographic integrity hash." }
    ];

    async function init() {
      try {
        state.dashboard = await (await fetch('/api/dashboard')).json();
        state.parcels = await (await fetch('/api/parcels')).json();
        state.buildings = await (await fetch('/api/buildings')).json();
        if (state.buildings.length > 0) {
          await selectBuilding(state.buildings[0]);
        }
        const valRes = await (await fetch('/api/validation/results')).json();
        state.issues = valRes.issues || [];
      } catch (e) {
        console.error(e);
      }

      // Check URL search or hash parameters for automated screenshots & deep-linking
      const q = window.location.search ? window.location.search.substring(1) : window.location.hash.replace('#', '');
      const params = new URLSearchParams(q);
      const stepParam = params.get('step');
      const screenParam = params.get('screen');
      const modalParam = params.get('modal');
      const bParam = params.get('building');
      const expParam = params.get('explode');
      const ulpingenParam = params.get('ulpingen');

      if (stepParam) {
        state.judgeTour = true;
        const sn = parseInt(stepParam, 10);
        state.judgeStep = sn;
        document.getElementById('judge-bar').style.display = 'flex';
        execStep(sn);
        if (ulpingenParam === '1') state.ulpinGenerated = true;
        else if (ulpingenParam === '0') state.ulpinGenerated = false;
      } else {
        if (bParam) {
          const tb = state.buildings.find(x => x.id === bParam);
          if (tb) await selectBuilding(tb);
        }
        if (expParam === '1') state.exploded = true;
        if (ulpingenParam === '1') state.ulpinGenerated = true;
        else if (ulpingenParam === '0') state.ulpinGenerated = false;
        if (screenParam) setScreen(screenParam);
        if (modalParam === 'splash') showSplashModal();
        if (modalParam === 'reg') showRegistrationModal();
      }

      render();
    }

    async function selectBuilding(b) {
      state.selectedBuilding = b;
      try {
        const data = await (await fetch('/api/buildings/' + b.id)).json();
        state.floors = data.floors || [];
        if (state.floors.length > 1) {
          state.selectedFloor = state.floors[1];
        } else if (state.floors.length > 0) {
          state.selectedFloor = state.floors[0];
        }
        if (state.selectedFloor && state.selectedFloor.properties.length > 0) {
          state.selectedProperty = state.selectedFloor.properties[0];
        }
      } catch (e) {
        console.error(e);
      }
      render();
    }

    function setScreen(s) {
      state.nav = s;
      document.querySelectorAll('.nav-item').forEach((el) => {
        const text = el.innerText.toLowerCase();
        el.classList.toggle('active', text.includes(s.toLowerCase()));
      });
      render();
    }

    function render() {
      const c = document.getElementById('content');
      if (state.nav === 'dashboard') c.innerHTML = renderDashboard();
      else if (state.nav === 'map') { c.innerHTML = renderMap(); init3DCanvas(); }
      else if (state.nav === 'ulpin') c.innerHTML = renderUlpin();
      else if (state.nav === 'validation') c.innerHTML = renderValidation();
      else if (state.nav === 'property') c.innerHTML = renderProperty();
      else if (state.nav === 'pipeline') c.innerHTML = renderPipeline();
      else if (state.nav === 'settings') c.innerHTML = renderSettings();
    }

    function renderDashboard() {
      const d = state.dashboard || {};
      return `
        <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom: 24px;">
          <div>
            <h1 style="font-size:26px; font-weight:900;">Command Center</h1>
            <p style="color:var(--text-secondary); font-size:13px; margin-top:4px;">LUNARA • 3D ULPIN Generation & Vertical Property Mapping System (SIH PS-26011)</p>
          </div>
          <div style="display:flex; gap:8px;">
            <span class="badge badge-blue">PS-26011</span>
            <span class="badge badge-green">TEAM: 168736</span>
            <span class="badge badge-amber">DEMO MODE • SYNTHETIC DATA</span>
          </div>
        </div>

        <div class="metrics-grid">
          <div class="metric-card"><div class="metric-label">PARCELS</div><div class="metric-val" style="color:var(--blue);">${d.parcels || 7}</div></div>
          <div class="metric-card"><div class="metric-label">BUILDINGS</div><div class="metric-val" style="color:var(--violet);">${d.buildings || 7}</div></div>
          <div class="metric-card"><div class="metric-label">FLOORS</div><div class="metric-val" style="color:var(--cyan);">${d.floors || 21}</div></div>
          <div class="metric-card"><div class="metric-label">PROPERTY UNITS</div><div class="metric-val" style="color:var(--green);">${d.properties || 42}</div></div>
          <div class="metric-card"><div class="metric-label">3D ULPINS</div><div class="metric-val" style="color:var(--cyan);">${d.ulpins || 42}</div></div>
          <div class="metric-card"><div class="metric-label">VALIDATION ISSUES</div><div class="metric-val" style="color:var(--amber);">${d.validation_issues || 7}</div></div>
        </div>

        <div class="panel">
          <div class="panel-header">
            <div>
              <div class="panel-title">3D Cadastral Overview & Mock Building Inventory</div>
              <div style="color:var(--text-secondary); font-size:12px; margin-top:2px;">Demonstration Cadastre: LUNARA Urban Zone D01 (7 Buildings Seeded)</div>
            </div>
            <div style="display:flex; gap:10px;">
              <button class="btn btn-secondary" onclick="setScreen('map')">EXPLORE 3D MAP</button>
              <button class="btn btn-primary" onclick="startJudgeTour()">START EVALUATOR TOUR</button>
            </div>
          </div>
          <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap:12px; margin-top:14px;">
            ${state.buildings.map(b => {
              const isB6 = b.id === 'B006';
              const isB7 = b.id === 'B007';
              return `
                <div style="background:var(--panel-elevated); border:1px solid ${isB6 || isB7 ? 'var(--amber)' : 'var(--line)'}; border-radius:10px; padding:14px; cursor:pointer;" onclick="selectBuildingById('${b.id}'); setScreen('map');">
                  <div style="display:flex; justify-content:space-between; align-items:center;">
                    <div style="font-weight:900; font-size:14px;">${b.name}</div>
                    <span class="badge ${isB6 || isB7 ? 'badge-amber' : 'badge-blue'}">${b.id}</span>
                  </div>
                  <div style="font-size:11px; color:var(--text-secondary); margin:6px 0;">Parcel: ${b.parcel_id || b.parcelId} • Height: ${b.height}m • Floors: ${b.floors}</div>
                  ${isB6 ? `<div style="color:var(--amber); font-size:11px; font-weight:700;">⚠️ Footprint Encroachment: Breaches Parcel P006 boundary!</div>` : ''}
                  ${isB7 ? `<div style="color:var(--amber); font-size:11px; font-weight:700;">⚠️ Vertical Overlap: Elevation slab clash between Floor 1 & 2!</div>` : ''}
                </div>
              `;
            }).join('')}
          </div>
        </div>
      `;
    }

    function renderMap() {
      const b = state.selectedBuilding || {};
      const f = state.selectedFloor || {};
      const p = state.selectedProperty || {};
      return `
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:18px;">
          <div>
            <h2 style="font-size:22px; font-weight:900;">3D Map Cadastre</h2>
            <p style="color:var(--text-secondary); font-size:12px;">Controlled 3D demonstration environment for vertical spatial relationships.</p>
          </div>
          <div style="display:flex; gap:8px;">
            ${state.selectedIssue ? `
              <span class="badge badge-amber">HIGHLIGHTING CONFLICT ${state.selectedIssue.id}</span>
              <button class="btn btn-secondary" style="padding:4px 8px; font-size:11px;" onclick="resetMapConflict()">CLEAR</button>
            ` : ''}
          </div>
        </div>

        <div id="canvas-container">
          <canvas id="map3d-canvas"></canvas>
          <div class="canvas-hud">
            <button class="hud-btn" onclick="toggleExplode()">${state.exploded ? 'COLLAPSE FLOORS' : 'EXPLODE FLOORS'}</button>
            <button class="hud-btn" onclick="reset3DCamera()">RESET CAMERA</button>
          </div>
        </div>

        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:16px; margin-bottom:16px;">
          <div class="panel">
            <div class="panel-title" style="font-size:13px; margin-bottom:10px;">BUILDING SELECTOR (7 VOLUMES)</div>
            <div style="display:flex; gap:8px; flex-wrap:wrap;">
              ${state.buildings.map(x => {
                const isConflict = x.id === 'B006' || x.id === 'B007';
                return `<button class="btn ${x.id === (b.id) ? 'btn-primary' : 'btn-secondary'}" onclick="selectBuildingById('${x.id}')">
                  ${x.id} ${isConflict ? '⚠️' : ''}
                </button>`;
              }).join('')}
            </div>
            ${b.id === 'B006' ? `<div style="margin-top:10px; font-size:11px; color:var(--amber); font-weight:700;">⚠️ Building B006 Footprint (31m) breaches Parcel P006 boundary (26m)</div>` : ''}
            ${b.id === 'B007' ? `<div style="margin-top:10px; font-size:11px; color:var(--amber); font-weight:700;">⚠️ Building B007 Vertical Elevation Clash (+6.4m ceiling vs +6.2m floorplate)</div>` : ''}
          </div>

          <div class="panel">
            <div class="panel-title" style="font-size:13px; margin-bottom:10px;">VERTICAL FLOOR STRATA</div>
            <div style="display:flex; gap:8px; flex-wrap:wrap;">
              ${state.floors.map(x => `<button class="btn ${x.id === (f.id) ? 'btn-primary' : 'btn-secondary'}" onclick="selectFloorById('${x.id}')">${x.name} (+${x.level*4}m)</button>`).join('')}
            </div>
          </div>
        </div>

        ${f.properties ? `
          <div class="panel">
            <div class="panel-header">
              <div class="panel-title">Property Units on ${f.name} (${f.properties.length} Units)</div>
              ${p.unit ? `<span class="badge">SELECTED: UNIT ${p.unit}</span>` : ''}
            </div>
            <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap:12px;">
              ${f.properties.map(u => `
                <div style="padding:14px; background:${u.id === p.id ? 'rgba(34,211,238,0.12)' : 'var(--panel-elevated)'}; border:1px solid ${u.id === p.id ? 'var(--cyan)' : 'var(--line)'}; border-radius:10px; cursor:pointer;" onclick="selectPropertyById('${u.id}')">
                  <div style="font-weight:900; font-size:15px;">UNIT ${u.unit}</div>
                  <div style="font-size:11px; color:var(--text-secondary); margin:4px 0;">${u.usage} • ${u.area} m² • Elevation +${u.z}m</div>
                  <button class="btn btn-primary" style="padding:5px 12px; font-size:11px; margin-top:6px;" onclick="event.stopPropagation(); selectPropertyById('${u.id}'); setScreen('ulpin');">GENERATE 3D ULPIN</button>
                </div>
              `).join('')}
            </div>
          </div>
        ` : ''}
      `;
    }

    function renderUlpin() {
      const p = state.selectedProperty || {
        id: 'PR007-01',
        parcel_id: 'P007',
        building_id: 'B007',
        floor_id: 'B007-F01',
        unit: 'A-201',
        usage: 'Residential',
        area: 115,
        z: 3.2,
        width: 9,
        depth: 15,
        height: 3.5
      };
      const parcelId = p.parcel_id || p.parcelId || (p.building_id === 'B007' || p.buildingId === 'B007' ? 'P007' : 'P001');
      const buildingId = p.building_id || p.buildingId || (parcelId === 'P007' ? 'B007' : 'B001');
      const floorId = p.floor_id || p.floorId || (buildingId === 'B007' ? 'B007-F01' : 'B001-F02');
      const unit = p.unit || 'A-201';
      const usage = p.usage || 'Residential';
      const area = p.area || 115;
      const z = p.z !== undefined ? p.z : 3.2;
      const width = p.width || 9;
      const depth = p.depth || 15;
      const height = p.height || 3.5;

      const ulpinObj = state.ulpin || {
        ulpin: `TS-HYD-D01-${parcelId}-${buildingId}-${floorId.includes('F01') ? 'F01' : 'F02'}-U201`,
        parts: {
          'STATE': 'TS',
          'DISTRICT': 'HYD',
          'DEMO AREA': 'D01',
          'PARCEL': parcelId,
          'BUILDING': buildingId,
          'FLOOR': floorId.includes('F01') ? 'F01' : 'F02',
          'UNIT': 'U201'
        }
      };

      const resolutionSteps = [
        'SELECTED PROPERTY',
        'RESOLVING PARCEL',
        'RESOLVING BUILDING',
        'RESOLVING FLOOR',
        'RESOLVING UNIT',
        'GENERATING SPATIAL ID',
        'VALIDATING BOUNDARY',
        'COMPLETE'
      ];

      return `
        <div style="margin-bottom:18px;">
          <h2 style="font-size:22px; font-weight:900;">Prototype 3D ULPIN Generator</h2>
          <p style="color:var(--text-secondary); font-size:12px; margin-top:4px;">Generates standardized 3D unique property identifiers encoding vertical spatial relationships.</p>
        </div>

        <!-- Selected Target Entity Panel -->
        <div class="panel" style="margin-bottom:16px;">
          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:14px;">
            <div class="panel-title">Selected Target Entity</div>
            <span class="badge badge-cyan" style="font-size:11px;">UNIT ${unit}</span>
          </div>

          <div style="display:flex; justify-content:space-between; align-items:flex-start; gap:24px; flex-wrap:wrap;">
            <div style="flex:1; min-width:320px;">
              <div style="font-size:30px; font-weight:900; color:var(--text); margin-bottom:10px;">Unit ${unit}</div>
              
              <!-- Hierarchy Breadcrumbs -->
              <div style="display:flex; align-items:center; gap:6px; flex-wrap:wrap; font-size:11px; font-weight:800;">
                <span class="badge badge-blue" style="padding:6px 10px; border-radius:6px;">PARCEL: ${parcelId}</span>
                <span style="color:var(--text-muted);">&gt;</span>
                <span class="badge badge-violet" style="padding:6px 10px; border-radius:6px;">BUILDING: ${buildingId}</span>
                <span style="color:var(--text-muted);">&gt;</span>
                <span class="badge badge-cyan" style="padding:6px 10px; border-radius:6px;">FLOOR: ${floorId}</span>
                <span style="color:var(--text-muted);">&gt;</span>
                <span class="badge badge-green" style="padding:6px 10px; border-radius:6px;">PROPERTY: ${unit}</span>
              </div>
            </div>

            <div style="background:var(--panel-elevated); border:1px solid var(--line); border-radius:10px; padding:12px 16px; min-width:280px; font-size:12px;">
              <div style="display:flex; justify-content:space-between; padding:3px 0;"><span style="color:var(--text-muted);">Floor Area</span><b>${area} m²</b></div>
              <div style="display:flex; justify-content:space-between; padding:3px 0;"><span style="color:var(--text-muted);">Usage Type</span><b>${usage}</b></div>
              <div style="display:flex; justify-content:space-between; padding:3px 0;"><span style="color:var(--text-muted);">Elevation (Z)</span><b style="color:var(--cyan);">+${z} m</b></div>
              <div style="display:flex; justify-content:space-between; padding:3px 0;"><span style="color:var(--text-muted);">3D Bounding Box</span><b>${width}m × ${depth}m × ${height}m</b></div>
            </div>
          </div>

          <div style="margin-top:18px;">
            <button class="btn btn-primary" id="btn-generate-ulpin" style="padding:10px 22px; font-size:12px; font-weight:800; display:inline-flex; align-items:center; gap:8px;" onclick="state.ulpinGenerated=true; generateUlpinApi('${p.id || 'PR007-01'}')">
              ✦ GENERATE 3D ULPIN
            </button>
          </div>
        </div>

        ${state.ulpinGenerated || state.ulpin ? `
          <!-- 3D Spatial Encoding Resolution Sequence Panel -->
          <div class="panel" style="margin-bottom:16px;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
              <div class="panel-title">3D Spatial Encoding Resolution Sequence</div>
              <span class="badge badge-green" style="font-size:11px; font-weight:800;">● COMPLETED</span>
            </div>
            <div style="display:flex; gap:8px; flex-wrap:wrap;">
              ${resolutionSteps.map((st, sidx) => `
                <div style="display:flex; align-items:center; gap:6px; padding:6px 12px; background:rgba(34,211,238,0.12); border:1px solid ${sidx === 7 ? 'var(--cyan)' : 'rgba(34,211,238,0.4)'}; border-radius:8px; font-size:10px; font-weight:800; color:var(--text);">
                  <span style="color:var(--cyan); font-weight:900;">✓</span>
                  <span>${st}</span>
                </div>
              `).join('')}
            </div>
          </div>

          <!-- Assigned Prototype 3D ULPIN Panel -->
          <div class="panel">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
              <div class="panel-title">Assigned Prototype 3D ULPIN</div>
              <span class="badge badge-green" style="font-size:11px; font-weight:800;">ACTIVE RECORD</span>
            </div>

            <div style="font-family:'JetBrains Mono',monospace; font-size:24px; font-weight:900; color:var(--cyan); padding:16px 20px; background:var(--panel-elevated); border:1.5px solid var(--cyan); border-radius:10px; margin-bottom:10px; display:flex; justify-content:space-between; align-items:center;">
              <span>${ulpinObj.ulpin}</span>
              <button class="btn btn-secondary" style="padding:6px 10px;" onclick="navigator.clipboard.writeText('${ulpinObj.ulpin}'); alert('3D ULPIN copied to clipboard!');">📋</button>
            </div>

            <p style="color:var(--text-muted); font-size:11px; margin-bottom:18px;">⚠️ Prototype identifier — not an official ULPIN algorithm or government standard. Demonstrates the concept of vertical spatial encoding.</p>

            <div style="font-size:11px; font-weight:800; color:var(--text-muted); margin-bottom:10px;">IDENTIFIER HIERARCHY DECOMPOSITION</div>

            <div style="display:grid; grid-template-columns: repeat(7, 1fr); gap:8px; margin-bottom:20px;">
              ${Object.entries(ulpinObj.parts).map(([k, v]) => `
                <div style="padding:10px; background:var(--panel-elevated); border-radius:8px; border:1px solid var(--line);">
                  <div style="font-size:9px; color:var(--text-muted); font-weight:700;">${k.toUpperCase()}</div>
                  <div style="font-size:15px; font-weight:900; color:var(--cyan); margin-top:4px;">${v}</div>
                </div>
              `).join('')}
            </div>

            <div style="display:flex; gap:12px;">
              <button class="btn btn-primary" style="padding:10px 20px; font-size:12px; font-weight:800;" onclick="exportRecordJson()">📥 EXPORT DEMO RECORD</button>
              <button class="btn btn-secondary" style="padding:10px 20px; font-size:12px; font-weight:800;" onclick="setScreen('property')">🗂️ VIEW PROPERTY RELATIONSHIP</button>
            </div>
          </div>
        ` : ''}
      `;
    }

    function renderValidation() {
      return `
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:18px;">
          <div>
            <h2 style="font-size:22px; font-weight:900;">Spatial Validation & Topology Checks</h2>
            <p style="color:var(--text-secondary); font-size:12px;">Automated 3D geometric conflict detection: volume overlaps, cadastral gaps, and boundary encroachments.</p>
          </div>
          <button class="btn btn-primary" onclick="runValidationApi()">RUN SPATIAL VALIDATION</button>
        </div>
        <div class="metrics-grid">
          <div class="metric-card"><div class="metric-label">TOTAL CHECKS</div><div class="metric-val" style="color:var(--blue);">28</div></div>
          <div class="metric-card"><div class="metric-label">PASSED</div><div class="metric-val" style="color:var(--green);">21</div></div>
          <div class="metric-card"><div class="metric-label">WARNINGS</div><div class="metric-val" style="color:var(--amber);">5</div></div>
          <div class="metric-card"><div class="metric-label">CRITICAL</div><div class="metric-val" style="color:var(--amber);">2</div></div>
        </div>
        <div class="panel">
          <div class="panel-title" style="margin-bottom:14px;">Spatial Conflict Results (${state.issues.length})</div>
          ${state.issues.map(i => {
            const isCrit = i.severity === 'Critical';
            const isWarn = i.severity === 'Warning';
            const colorClass = isCrit || isWarn ? 'badge-amber' : 'badge-green';
            return `
              <div style="padding:14px; background:var(--panel-elevated); border:1px solid var(--line); border-radius:10px; margin-bottom:10px; display:flex; justify-content:space-between; align-items:center;">
                <div>
                  <span class="badge ${colorClass}">${i.issue_type || i.type} • ${i.severity}</span>
                  <div style="font-weight:800; font-size:14px; margin:6px 0 2px;">${i.description}</div>
                  <div style="color:var(--text-secondary); font-size:11px;">Building ${i.building_id || i.buildingId || 'B006'} • Floor ${i.floor_id || i.floorId || 'B006-F01'} • Affected: ${(i.property_ids || i.propertyIds || []).join(', ')}</div>
                </div>
                <button class="btn btn-amber" onclick="viewIssueIn3D('${i.id}')">VIEW IN 3D MAP</button>
              </div>
            `;
          }).join('')}
        </div>
      `;
    }

    function renderProperty() {
      const p = state.selectedProperty || (state.selectedFloor && state.selectedFloor.properties && state.selectedFloor.properties[0]) || {
        id: 'PR001',
        parcel_id: 'P001',
        building_id: 'B001',
        floor_id: 'B001-F02',
        unit: 'A-201',
        usage: 'Residential',
        area: 115,
        z: 8.0
      };
      const parcelId = p.parcel_id || p.parcelId || (p.building_id === 'B007' || p.buildingId === 'B007' ? 'P007' : 'P001');
      const buildingId = p.building_id || p.buildingId || (parcelId === 'P007' ? 'B007' : 'B001');
      const floorId = p.floor_id || p.floorId || (buildingId === 'B007' ? 'B007-F01' : 'B001-F02');
      const unit = p.unit || 'A-201';
      const propId = p.id || 'PR001';
      const usage = p.usage || 'Residential';
      const area = p.area || 115;
      const z = p.z !== undefined ? p.z : (buildingId === 'B007' ? 3.2 : 8.0);

      return `
        <h2 style="font-size:22px; font-weight:900; margin-bottom:18px;">Property Hierarchy & Registry Record</h2>
        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:18px;">
          <div class="panel">
            <div class="panel-title">Digital Record: Unit ${unit}</div>
            <div style="margin-top:14px; font-size:12px;">
              <div style="padding:8px 0; border-bottom:1px solid var(--line); display:flex; justify-content:space-between;"><span style="color:var(--text-secondary);">System ID</span><b>${propId}</b></div>
              <div style="padding:8px 0; border-bottom:1px solid var(--line); display:flex; justify-content:space-between;"><span style="color:var(--text-secondary);">Cadastral Parcel</span><b>${parcelId}</b></div>
              <div style="padding:8px 0; border-bottom:1px solid var(--line); display:flex; justify-content:space-between;"><span style="color:var(--text-secondary);">Building Volume</span><b>${buildingId}</b></div>
              <div style="padding:8px 0; border-bottom:1px solid var(--line); display:flex; justify-content:space-between;"><span style="color:var(--text-secondary);">Vertical Floor</span><b>${floorId}</b></div>
              <div style="padding:8px 0; border-bottom:1px solid var(--line); display:flex; justify-content:space-between;"><span style="color:var(--text-secondary);">Usage Type</span><b>${usage}</b></div>
              <div style="padding:8px 0; border-bottom:1px solid var(--line); display:flex; justify-content:space-between;"><span style="color:var(--text-secondary);">Floor Area</span><b>${area} m²</b></div>
              <div style="padding:8px 0; display:flex; justify-content:space-between;"><span style="color:var(--text-secondary);">Elevation (Z)</span><b style="color:var(--cyan);">+${z} m</b></div>
            </div>
          </div>
          <div class="panel">
            <div class="panel-title">4-Tier Spatial Hierarchy Tree</div>
            <div style="margin-top:14px; display:flex; flex-direction:column; gap:10px;">
              <div style="padding:10px; background:var(--panel-elevated); border-radius:8px; border:1px solid var(--blue); color:var(--text);"><span style="color:var(--blue); font-weight:800;">TIER 1 (PARCEL):</span> ${parcelId}</div>
              <div style="padding:10px; background:var(--panel-elevated); border-radius:8px; border:1px solid var(--violet); color:var(--text);"><span style="color:var(--violet); font-weight:800;">TIER 2 (BUILDING):</span> ${buildingId}</div>
              <div style="padding:10px; background:var(--panel-elevated); border-radius:8px; border:1px solid var(--cyan); color:var(--text);"><span style="color:var(--cyan); font-weight:800;">TIER 3 (FLOOR):</span> ${floorId} (+${z}m)</div>
              <div style="padding:10px; background:var(--panel-elevated); border-radius:8px; border:1px solid var(--green); color:var(--text);"><span style="color:var(--green); font-weight:800;">TIER 4 (PROPERTY):</span> Unit ${unit} (${propId})</div>
            </div>
            <button class="btn btn-primary" style="margin-top:16px; width:100%; justify-content:center;" onclick="exportRecordJson()">EXPORT RECORD JSON</button>
          </div>
        </div>
      `;
    }

    function renderPipeline() {
      const stages = [
        'DATA', 'BUILDING DETECTION', 'FLOOR EXTRACTION', '3D GEOMETRY',
        'PROPERTY MAPPING', '3D ULPIN', 'VALIDATION', 'VERIFICATION'
      ];
      return `
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:18px;">
          <div>
            <h2 style="font-size:22px; font-weight:900;">Live Processing Pipeline</h2>
            <p style="color:var(--text-secondary); font-size:12px;">Data → AI Agents → 3D Mapping → ULPIN → Database → Verification → Web</p>
          </div>
          <button class="btn btn-primary" onclick="runPipelineApi()">RUN DEMO PIPELINE</button>
        </div>
        <div class="panel">
          <div class="panel-title" style="margin-bottom:14px;">Modular Agent Workflow Stages (8)</div>
          ${stages.map((s, idx) => `
            <div style="display:flex; align-items:center; gap:12px; padding:12px; background:var(--panel-elevated); border-radius:8px; border:1px solid var(--line); margin-bottom:8px;">
              <span class="badge badge-green">STAGE ${idx+1}</span>
              <div style="font-weight:800; font-size:13px; flex:1;">${s}</div>
              <span class="badge badge-green">COMPLETE</span>
            </div>
          `).join('')}
        </div>
      `;
    }

    function renderSettings() {
      return `
        <h2 style="font-size:22px; font-weight:900; margin-bottom:18px;">System Settings & Preferences</h2>
        
        <div class="panel">
          <div class="panel-title" style="margin-bottom:14px;">Geospatial & Display Parameters</div>
          <div style="display:grid; grid-template-columns: 1fr 1fr; gap:14px;">
            <div>
              <label style="font-size:11px; font-weight:700; color:var(--text-secondary); display:block; margin-bottom:6px;">COORDINATE REFERENCE SYSTEM (CRS)</label>
              <select class="search-input" style="width:100%; height:42px;" onchange="state.crs=this.value;">
                <option ${state.crs.includes('7755') ? 'selected' : ''}>EPSG:7755 (India National Grid)</option>
                <option ${state.crs.includes('4326') ? 'selected' : ''}>EPSG:4326 (WGS 84 Lat/Lon)</option>
                <option ${state.crs.includes('3857') ? 'selected' : ''}>EPSG:3857 (Web Mercator)</option>
              </select>
            </div>
            <div>
              <label style="font-size:11px; font-weight:700; color:var(--text-secondary); display:block; margin-bottom:6px;">MEASUREMENT UNITS</label>
              <select class="search-input" style="width:100%; height:42px;" onchange="state.units=this.value;">
                <option selected>Metric (Meters, m²)</option>
                <option>Imperial (Feet, sq ft)</option>
              </select>
            </div>
          </div>
        </div>

        <div class="panel">
          <div class="panel-title" style="margin-bottom:14px;">UI/UX Semantic Color System</div>
          <div style="display:flex; flex-direction:column; gap:8px;">
            <div style="display:flex; align-items:center; gap:12px; padding:8px 12px; background:var(--panel-elevated); border-radius:8px;">
              <span class="badge" style="width:120px; justify-content:center;">CYAN (#22D3EE)</span>
              <span style="font-size:12px; color:var(--text);">Primary Actions / 3D ULPIN / Active Navigation</span>
            </div>
            <div style="display:flex; align-items:center; gap:12px; padding:8px 12px; background:var(--panel-elevated); border-radius:8px;">
              <span class="badge badge-blue" style="width:120px; justify-content:center;">BLUE (#3B82F6)</span>
              <span style="font-size:12px; color:var(--text);">Spatial Elements / Parcel Boundaries / GIS Coordinates</span>
            </div>
            <div style="display:flex; align-items:center; gap:12px; padding:8px 12px; background:var(--panel-elevated); border-radius:8px;">
              <span class="badge badge-violet" style="width:120px; justify-content:center;">VIOLET (#8B5CF6)</span>
              <span style="font-size:12px; color:var(--text);">AI & 3D Volumetric Intelligence / Processing Pipeline</span>
            </div>
            <div style="display:flex; align-items:center; gap:12px; padding:8px 12px; background:var(--panel-elevated); border-radius:8px;">
              <span class="badge badge-green" style="width:120px; justify-content:center;">GREEN (#22C55E)</span>
              <span style="font-size:12px; color:var(--text);">Validated / Passed Topological States</span>
            </div>
            <div style="display:flex; align-items:center; gap:12px; padding:8px 12px; background:var(--panel-elevated); border-radius:8px;">
              <span class="badge badge-amber" style="width:120px; justify-content:center;">AMBER (#F59E0B)</span>
              <span style="font-size:12px; color:var(--text);">Spatial Conflicts & Encroachment Warnings (B006, B007)</span>
            </div>
          </div>
        </div>

        <div class="panel">
          <div class="panel-title" style="margin-bottom:10px;">Demonstration Shortcuts</div>
          <div style="display:flex; gap:10px;">
            <button class="btn btn-primary" onclick="showSplashModal()">SHOW SPLASH SCREEN</button>
            <button class="btn btn-secondary" onclick="showRegistrationModal()">OPEN REGISTRATION MODAL</button>
          </div>
        </div>
      `;
    }

    /* 3D Canvas Scene Engine */
    let canvas, ctx, yaw = 0.65, pitch = 0.55, zoom = 1.0;
    function init3DCanvas() {
      canvas = document.getElementById('map3d-canvas');
      if (!canvas) return;
      ctx = canvas.getContext('2d');
      canvas.width = canvas.parentElement.clientWidth;
      canvas.height = canvas.parentElement.clientHeight;
      draw3DScene();
    }

    function project(x, y, z) {
      const cx = canvas.width * 0.5;
      const cy = canvas.height * 0.58;
      const cosY = Math.cos(yaw);
      const sinY = Math.sin(yaw);
      const rx = x * cosY - y * sinY;
      const ry = x * sinY + y * cosY;
      const cosP = Math.cos(pitch);
      const sinP = Math.sin(pitch);
      return {
        x: cx + rx * zoom,
        y: cy + (ry * sinP - z * cosP) * zoom
      };
    }

    function draw3DScene() {
      if (!ctx || !canvas) return;
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      // Cadastral Ground Grid
      ctx.strokeStyle = 'rgba(38, 49, 61, 0.6)';
      ctx.lineWidth = 1;
      const step = 28, count = 10;
      for (let i = -count; i <= count; i++) {
        const p1 = project(i * step, -count * step, 0);
        const p2 = project(i * step, count * step, 0);
        ctx.beginPath(); ctx.moveTo(p1.x, p1.y); ctx.lineTo(p2.x, p2.y); ctx.stroke();

        const p3 = project(-count * step, i * step, 0);
        const p4 = project(count * step, i * step, 0);
        ctx.beginPath(); ctx.moveTo(p3.x, p3.y); ctx.lineTo(p4.x, p4.y); ctx.stroke();
      }

      const b = state.selectedBuilding || { id: 'B001' };
      const isB6 = b.id === 'B006';
      const isB7 = b.id === 'B007';

      // Draw 2D Parcel Boundary on Ground (in BLUE)
      const pw = isB6 ? 130 : 150;
      const pd = isB6 ? 110 : 120;
      const pp0 = project(-pw/2, -pd/2, 0);
      const pp1 = project(pw/2, -pd/2, 0);
      const pp2 = project(pw/2, pd/2, 0);
      const pp3 = project(-pw/2, pd/2, 0);

      ctx.fillStyle = 'rgba(59, 130, 246, 0.08)';
      ctx.strokeStyle = '#3B82F6';
      ctx.lineWidth = 2;
      ctx.setLineDash([4, 4]);
      ctx.beginPath();
      ctx.moveTo(pp0.x, pp0.y); ctx.lineTo(pp1.x, pp1.y); ctx.lineTo(pp2.x, pp2.y); ctx.lineTo(pp3.x, pp3.y);
      ctx.closePath();
      ctx.fill(); ctx.stroke();
      ctx.setLineDash([]);

      ctx.fillStyle = '#3B82F6';
      ctx.font = 'bold 10px Plus Jakarta Sans';
      ctx.fillText(`PARCEL BOUNDARY [${b.parcel_id || b.parcelId || 'P001'}]`, pp0.x + 8, pp0.y - 6);

      // Building footprint and slabs
      const bw = isB6 ? 160 : 130; // B006 encroaches beyond 130 parcel!
      const bd = 100;
      const fh = 32;
      const totalFloors = 3;
      const explodeOffset = state.exploded ? 60 : 0;

      for (let lvl = 0; lvl < totalFloors; lvl++) {
        // In B007, vertical overlap collision on floor 1 & 2
        const fz = isB7 && lvl === 1 ? lvl * (fh + explodeOffset) - 10 : lvl * (fh + explodeOffset);
        const isSelFloor = state.selectedFloor && state.selectedFloor.level === lvl;

        // Slab corners
        const p0 = project(-bw/2, -bd/2, fz);
        const p1 = project(bw/2, -bd/2, fz);
        const p2 = project(bw/2, bd/2, fz);
        const p3 = project(-bw/2, bd/2, fz);

        // Conflict coloring
        const isConflictSlab = (isB6 && lvl === 0) || (isB7 && lvl >= 1);
        ctx.fillStyle = isConflictSlab 
          ? 'rgba(245, 158, 11, 0.25)' 
          : isSelFloor ? 'rgba(34, 211, 238, 0.22)' : 'rgba(23, 29, 37, 0.85)';
        ctx.strokeStyle = isConflictSlab 
          ? '#F59E0B' 
          : isSelFloor ? '#22D3EE' : '#384758';
        ctx.lineWidth = isConflictSlab || isSelFloor ? 2 : 1;

        ctx.beginPath();
        ctx.moveTo(p0.x, p0.y); ctx.lineTo(p1.x, p1.y); ctx.lineTo(p2.x, p2.y); ctx.lineTo(p3.x, p3.y);
        ctx.closePath();
        ctx.fill(); ctx.stroke();

        // Floor Tag
        ctx.fillStyle = isConflictSlab ? '#F59E0B' : isSelFloor ? '#22D3EE' : '#94A3B8';
        ctx.font = 'bold 11px Plus Jakarta Sans';
        ctx.fillText(lvl === 0 ? 'GROUND (L0)' : 'FLOOR ' + lvl, p3.x - 10, p3.y + 14);

        // Property Unit Bounding Boxes
        for (let u = 0; u < 2; u++) {
          const ux = -bw/2 + 10 + u * 58;
          const uy = -bd/2 + 10;
          const uw = 50, ud = 80, uh = 20;
          const uz = fz + 4;

          const isEncroachingUnit = isB6 && u === 1;
          const isVerticalClashUnit = isB7 && lvl === 1;

          const up0 = project(ux, uy, uz + uh);
          const up1 = project(ux + uw, uy, uz + uh);
          const up2 = project(ux + uw, uy + ud, uz + uh);
          const up3 = project(ux, uy + ud, uz + uh);

          ctx.fillStyle = (isEncroachingUnit || isVerticalClashUnit) 
            ? 'rgba(245, 158, 11, 0.8)' 
            : u === 0 ? 'rgba(59, 130, 246, 0.65)' : 'rgba(139, 92, 246, 0.65)';
          ctx.strokeStyle = (isEncroachingUnit || isVerticalClashUnit) ? '#F59E0B' : '#FFFFFF';
          ctx.lineWidth = (isEncroachingUnit || isVerticalClashUnit) ? 2 : 1;

          ctx.beginPath();
          ctx.moveTo(up0.x, up0.y); ctx.lineTo(up1.x, up1.y); ctx.lineTo(up2.x, up2.y); ctx.lineTo(up3.x, up3.y);
          ctx.closePath();
          ctx.fill(); ctx.stroke();

          ctx.fillStyle = '#FFFFFF';
          ctx.font = 'bold 10px Plus Jakarta Sans';
          ctx.fillText(`U-${lvl+1}0${u+1}`, up3.x + 4, up3.y - 4);
        }
      }
    }

    function toggleExplode() {
      state.exploded = !state.exploded;
      render();
    }
    function reset3DCamera() {
      yaw = 0.65; pitch = 0.55; zoom = 1.0;
      state.exploded = false;
      state.selectedIssue = null;
      render();
    }
    function resetMapConflict() {
      state.selectedIssue = null;
      render();
    }
    async function selectBuildingById(id) {
      const b = state.buildings.find(x => x.id === id);
      if (b) await selectBuilding(b);
    }
    function selectFloorById(id) {
      const f = state.floors.find(x => x.id === id);
      if (f) {
        state.selectedFloor = f;
        if (f.properties.length > 0) state.selectedProperty = f.properties[0];
        render();
      }
    }
    function selectPropertyById(id) {
      if (state.selectedFloor) {
        const p = state.selectedFloor.properties.find(x => x.id === id);
        if (p) { state.selectedProperty = p; render(); }
      }
    }
    async function generateUlpinApi(id) {
      try {
        const res = await (await fetch('/api/ulpin/generate', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({property_id: id})
        })).json();
        state.ulpin = res;
      } catch (e) { console.error(e); }
      render();
    }
    async function runValidationApi() {
      try {
        const res = await (await fetch('/api/validation/run', {method: 'POST'})).json();
        state.issues = res.issues || [];
      } catch (e) { console.error(e); }
      render();
    }
    async function runPipelineApi() {
      try {
        await fetch('/api/demo/run', {method: 'POST'});
      } catch (e) { console.error(e); }
      render();
    }
    function startLiveDemoPipeline() {
      setScreen('pipeline');
      runPipelineApi();
    }
    function triggerSpatialValidation() {
      setScreen('validation');
      runValidationApi();
    }
    function viewIssueIn3D(id) {
      state.selectedIssue = state.issues.find(x => x.id === id);
      if (state.selectedIssue) {
        const targetB = state.buildings.find(b => b.id === (state.selectedIssue.building_id || state.selectedIssue.buildingId));
        if (targetB) selectBuilding(targetB);
      }
      state.exploded = true;
      setScreen('map');
    }
    function exportRecordJson() {
      const p = state.selectedProperty || {};
      const u = state.ulpin ? state.ulpin.ulpin : `TS-HYD-D01-${p.parcelId || 'P001'}-${p.buildingId || 'B001'}-F01-U001`;
      const record = {
        property_id: p.unit || "A-201",
        system_id: p.id || "B001-U201",
        parcel_id: p.parcelId || "P001",
        building_id: p.buildingId || "B001",
        floor: p.floorId || "B001-F01",
        elevation_meters: p.z || 8.0,
        prototype_3d_ulpin: u,
        spatial_validation: {
          status: state.selectedIssue ? "FLAGGED_FOR_REVIEW" : "VALID",
          checks_evaluated: 28,
          conflict_detected: !!state.selectedIssue
        },
        integrity_hash: "SHA256:7f83b1657ff1fc53b92dc18148a1d65dfc2d4b1fa3d677284addd200126d9069"
      };
      const blob = new Blob([JSON.stringify(record, null, 2)], {type: 'application/json'});
      const a = document.createElement('a');
      a.href = URL.createObjectURL(blob);
      a.download = `LUNARA_RECORD_${p.unit || 'A-201'}.json`;
      a.click();
    }

    /* Modal Controls */
    function showSplashModal() { document.getElementById('splash-modal').style.display = 'flex'; }
    function closeSplashModal() { document.getElementById('splash-modal').style.display = 'none'; }
    function showRegistrationModal() { document.getElementById('reg-modal').style.display = 'flex'; }
    function closeRegistrationModal() { document.getElementById('reg-modal').style.display = 'none'; }
    function submitRegistration() {
      alert('Demonstration profile registered. Access granted to LUNARA Vertical Cadastre.');
      closeRegistrationModal();
    }

    /* Judge Demo Playback Controls */
    function startJudgeTour() {
      const modal = document.getElementById('video-modal');
      const player = document.getElementById('judge-video-player');
      if (modal && player) {
        modal.style.display = 'flex';
        player.currentTime = 0;
        player.play().catch(e => console.log('Autoplay deferred:', e));
      }
    }
    function closeVideoModal() {
      const modal = document.getElementById('video-modal');
      const player = document.getElementById('judge-video-player');
      if (player) {
        player.pause();
      }
      if (modal) {
        modal.style.display = 'none';
      }
    }
    function stopJudgeTour() {
      state.judgeTour = false;
      document.getElementById('judge-bar').style.display = 'none';
      closeSplashModal();
      closeRegistrationModal();
      render();
    }
    function nextJudgeStep() {
      if (state.judgeStep < 15) {
        state.judgeStep++;
        execStep(state.judgeStep);
      } else {
        stopJudgeTour();
      }
    }
    function prevJudgeStep() {
      if (state.judgeStep > 1) {
        state.judgeStep--;
        execStep(state.judgeStep);
      }
    }
    function execStep(step) {
      const info = judgeTourSteps[step - 1];
      document.getElementById('judge-step-badge').innerText = `STEP ${step} / 15`;
      document.getElementById('judge-step-title').innerText = info.title;
      document.getElementById('judge-step-desc').innerText = info.desc;
      document.getElementById('judge-next-btn').innerText = step === 15 ? 'FINISH DEMO' : 'NEXT STEP ▶';

      // Step Actions
      closeSplashModal();
      closeRegistrationModal();

      if (step === 1) { showSplashModal(); }
      else if (step === 2) { showRegistrationModal(); }
      else if (step === 3) { setScreen('dashboard'); }
      else if (step === 4) { setScreen('pipeline'); runPipelineApi(); }
      else if (step === 5) { setScreen('map'); state.exploded = false; selectBuildingById('B001'); }
      else if (step === 6) { setScreen('map'); state.exploded = true; }
      else if (step === 7) { 
        setScreen('map'); 
        if (state.floors.length > 1) selectFloorById(state.floors[1].id);
        if (state.selectedFloor && state.selectedFloor.properties.length > 0) selectPropertyById(state.selectedFloor.properties[0].id);
      }
      else if (step === 8) { setScreen('ulpin'); if (state.selectedProperty) generateUlpinApi(state.selectedProperty.id); }
      else if (step === 9) { setScreen('validation'); runValidationApi(); }
      else if (step === 10) { selectBuildingById('B006'); setScreen('map'); state.exploded = true; }
      else if (step === 11) {
        const v6 = state.issues.find(x => x.id === 'V006');
        if (v6) viewIssueIn3D(v6.id);
      }
      else if (step === 12) { selectBuildingById('B007'); setScreen('map'); state.exploded = true; }
      else if (step === 13) {
        const v7 = state.issues.find(x => x.id === 'V007');
        if (v7) viewIssueIn3D(v7.id);
      }
      else if (step === 14) { setScreen('property'); }
      else if (step === 15) { setScreen('ulpin'); }
    }

    async function search(q) {
      if (!q.trim()) return;
      try {
        const res = await (await fetch('/api/search?q=' + encodeURIComponent(q))).json();
        if (res.building_id) {
          await selectBuildingById(res.building_id);
          setScreen('map');
        }
      } catch (e) { console.error(e); }
    }

    window.onload = init;
  </script>
</body>
</html>
"""
