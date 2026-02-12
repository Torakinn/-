let currentHack = null;
let hackTimer = null;
let hackType = null;
let timeRemaining = 0;

// NUIメッセージを受信
window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'startHack') {
        startHack(data.hackType, data.time);
    }
});

// ESCキーで閉じる
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeHack();
    }
});

function startHack(type, time) {
    hackType = type;
    timeRemaining = time;
    
    document.getElementById('hack-container').classList.remove('hidden');
    
    if (type === 'security') {
        startSecurityHack();
    } else if (type === 'door') {
        startDoorHack();
    } else if (type === 'vault') {
        startVaultHack();
    }
    
    startTimer(type);
}

function startTimer(type) {
    const timerElement = document.getElementById(`${type}-timer`);
    
    hackTimer = setInterval(() => {
        timeRemaining--;
        timerElement.textContent = timeRemaining;
        
        if (timeRemaining <= 10) {
            timerElement.classList.add('warning');
        }
        
        if (timeRemaining <= 0) {
            hackFailed();
        }
    }, 1000);
}

function stopTimer() {
    if (hackTimer) {
        clearInterval(hackTimer);
        hackTimer = null;
    }
}

function closeHack() {
    stopTimer();
    document.getElementById('hack-container').classList.add('hidden');
    document.querySelectorAll('.hack-type').forEach(el => el.classList.add('hidden'));
    
    fetch(`https://${GetParentResourceName()}/closeHack`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function hackSuccess() {
    stopTimer();
    
    fetch(`https://${GetParentResourceName()}/hackSuccess`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ hackType: hackType })
    });
    
    setTimeout(() => {
        closeHack();
    }, 500);
}

function hackFailed() {
    stopTimer();
    
    fetch(`https://${GetParentResourceName()}/hackFailed`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ hackType: hackType })
    });
    
    setTimeout(() => {
        closeHack();
    }, 500);
}

// セキュリティハック - スキルチェック
function startSecurityHack() {
    document.getElementById('security-hack').classList.remove('hidden');
    
    let successCount = 0;
    const requiredSuccess = 3;
    
    document.addEventListener('keydown', function skillCheckHandler(event) {
        if (event.code === 'Space') {
            const indicator = document.querySelector('.skill-check-indicator');
            const target = document.querySelector('.skill-check-target');
            
            // 回転角度を計算
            const indicatorRotation = 0; // 常に上を向いている
            const targetRotation = parseFloat(getComputedStyle(target).transform.split(',')[1]) || 0;
            
            // 成功判定（簡略化）
            const random = Math.random();
            if (random > 0.3) { // 70%の成功率
                successCount++;
                
                if (successCount >= requiredSuccess) {
                    document.removeEventListener('keydown', skillCheckHandler);
                    hackSuccess();
                }
            } else {
                document.removeEventListener('keydown', skillCheckHandler);
                hackFailed();
            }
        }
    });
}

// ドアハック - 記憶ゲーム
function startDoorHack() {
    document.getElementById('door-hack').classList.remove('hidden');
    
    const gridSize = 16;
    const sequenceLength = 5;
    const grid = document.getElementById('memory-grid');
    grid.innerHTML = '';
    
    const sequence = [];
    const tiles = [];
    
    // グリッド生成
    for (let i = 0; i < gridSize; i++) {
        const tile = document.createElement('div');
        tile.className = 'memory-tile';
        tile.dataset.index = i;
        grid.appendChild(tile);
        tiles.push(tile);
    }
    
    // ランダムシーケンス生成
    while (sequence.length < sequenceLength) {
        const rand = Math.floor(Math.random() * gridSize);
        if (!sequence.includes(rand)) {
            sequence.push(rand);
        }
    }
    
    // シーケンスを表示
    let displayIndex = 0;
    const displayInterval = setInterval(() => {
        if (displayIndex < sequence.length) {
            const tileIndex = sequence[displayIndex];
            tiles[tileIndex].classList.add('active');
            
            setTimeout(() => {
                tiles[tileIndex].classList.remove('active');
            }, 500);
            
            displayIndex++;
        } else {
            clearInterval(displayInterval);
            startMemoryInput(tiles, sequence);
        }
    }, 800);
}

function startMemoryInput(tiles, sequence) {
    let inputIndex = 0;
    
    tiles.forEach(tile => {
        tile.addEventListener('click', function memoryClickHandler() {
            const clickedIndex = parseInt(this.dataset.index);
            
            if (clickedIndex === sequence[inputIndex]) {
                this.classList.add('correct');
                inputIndex++;
                
                if (inputIndex === sequence.length) {
                    tiles.forEach(t => t.removeEventListener('click', memoryClickHandler));
                    hackSuccess();
                }
            } else {
                this.classList.add('wrong');
                tiles.forEach(t => t.removeEventListener('click', memoryClickHandler));
                setTimeout(() => {
                    hackFailed();
                }, 500);
            }
        });
    });
}

// 金庫ハック - 指紋認証
function startVaultHack() {
    document.getElementById('vault-hack').classList.remove('hidden');
    
    const canvas = document.getElementById('fingerprint-canvas');
    const ctx = canvas.getContext('2d');
    let rotation = Math.floor(Math.random() * 360);
    const targetRotation = 0;
    const tolerance = 15; // 許容角度
    
    // 指紋パターンを描画
    function drawFingerprint(angle) {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        
        ctx.save();
        ctx.translate(canvas.width / 2, canvas.height / 2);
        ctx.rotate((angle * Math.PI) / 180);
        
        // 指紋パターンを描画（簡略化）
        ctx.strokeStyle = '#00ff88';
        ctx.lineWidth = 2;
        
        for (let i = 0; i < 10; i++) {
            ctx.beginPath();
            ctx.ellipse(0, 0, 20 + i * 15, 30 + i * 20, 0, 0, Math.PI * 2);
            ctx.stroke();
        }
        
        // ユニークなマーク
        ctx.fillStyle = '#ff0044';
        ctx.fillRect(-10, -80, 20, 20);
        
        ctx.restore();
    }
    
    drawFingerprint(rotation);
    
    // 回転ボタン
    document.getElementById('rotate-left').addEventListener('click', function() {
        rotation = (rotation - 15 + 360) % 360;
        drawFingerprint(rotation);
    });
    
    document.getElementById('rotate-right').addEventListener('click', function() {
        rotation = (rotation + 15) % 360;
        drawFingerprint(rotation);
    });
    
    // 確認ボタン
    document.getElementById('submit-fingerprint').addEventListener('click', function() {
        const diff = Math.abs(rotation - targetRotation);
        
        if (diff <= tolerance || diff >= (360 - tolerance)) {
            hackSuccess();
        } else {
            hackFailed();
        }
    });
}

// GetParentResourceName helper
function GetParentResourceName() {
    // リソース名をパスから抽出、フォールバックとしてデフォルト名を使用
    const match = window.location.pathname.match(/\/([^/]+)\/html/);
    return match ? match[1] : 'qb-cayoperico'; // デフォルトリソース名
}
