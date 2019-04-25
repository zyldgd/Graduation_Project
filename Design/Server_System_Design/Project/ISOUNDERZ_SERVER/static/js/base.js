function getMax(array) {
    let temp = [];
    for (let y = 0; y < array.length; y++) {
        temp[y] = Math.max.apply(Math, array[y]);
        if (isNaN(temp[y])) {
            temp[y] = 0;
        }
    }

    return Math.max.apply(Math, temp);
}

function getMin(array) {
    let temp = [];
    for (let y = 0; y < array.length; y++) {
        temp[y] = Math.min.apply(Math, array[y]);
        if (isNaN(temp[y])) {
            temp[y] = 10000;
        }
    }

    return Math.min.apply(Math, temp);
}

function MAP(val, min, max, smin, smax) {
    return (val - min) / (max - min) * (smax - smin);
}

function limit(v, min, max) {
    return v < min ? min : (v > max ? max : v);
}

function HSV(x, offset) {
    if ((x - offset) < 0.375) {
        return parseInt(limit(1024 * (x - offset), 0, 255));
    }
    else {
        return parseInt(limit(768 - 1024 * (x - offset), 0, 255));
    }
}

function getFIleInfo(fileName) {
    let arr = fileName.split(/[,_]/);
    let index = fileName.lastIndexOf(".");
    let ext = fileName.substr(index + 1).toString().toUpperCase();
    if (ext === "SOS") {
        return {
            codeType: arr[0],
            frequency: parseFloat(arr[1]),
            PSN: parseInt(arr[2]),
            codeLen: parseInt(arr[3]),
            RMAX: parseInt(arr[4]),
            covLen: parseInt(arr[4]) - parseInt(arr[3]) + 1,
            PRT: parseInt(arr[5]),
            date: arr[6],
            time: arr[7],
            latitude: arr[8],
            longitude: arr[9],
            chanel: parseInt(arr[11]),
            ext: ext
        };
    }
    else if (ext === "COS") {
        return {
            codeType: arr[0],
            PSN: parseInt(arr[1]),
            freqStart: parseFloat(arr[2]),
            freqStep: parseFloat(arr[3]) / 1000,
            freqEnd: parseFloat(arr[4]),
            freqSpan: parseInt((parseFloat(arr[4]) - parseFloat(arr[2])) / (parseFloat(arr[3]) / 1000)),
            codeLen: parseInt(arr[5]),
            covLen: parseInt(arr[6]) - parseInt(arr[5]) + 1,
            RMAX: parseInt(arr[6]),
            PRT: parseInt(arr[7]),
            date: arr[8],
            time: arr[9],
            latitude: arr[10],
            longitude: arr[11],
            chanel: parseInt(arr[13]),
            ext: ext
        };
    }
    else if (ext === "AMP")
        return false;
}

function createArray(w, h) {
    let tempArr = new Array(h);
    for (let i = 0; i < h; i++) {
        tempArr[i] = new Array(w);
    }
    return tempArr;
}

function formatDateTime(date, time) {
    let D = date;
    let T = time;
    if (date.search("-") === -1) {
        D = date.substr(0, 4) + "-" + date.substr(4, 2) + "-" + date.substr(6, 2);
    }
    if (time.search(":") === -1) {
        T = time.substr(0, 2) + ":" + time.substr(2, 2) + ":" + time.substr(4, 2);
    }
    return [D, T];
}

function transpose(array) {
    let w = array.length;
    let h = array[0].length;

    let newArray = new Array(h);

    for (let i = 0; i < h; i++) {
        newArray[i] = new Array(w);
        for (let j = 0; j < w; j++) {
            newArray[i][j] = array[j][i];
        }
    }
    return newArray;
}

//-------------------------------------------------
var C16ACode = [1, 1, -1, 1, 1, 1, 1, -1, 1, -1, -1, -1, 1, -1, 1, 1];
var C16BCode = [1, 1, -1, 1, 1, 1, 1, -1, -1, 1, 1, 1, -1, 1, -1, -1];


function IonoDiagramLayer(mainCanvas, probeData) {
    if (probeData === null) {
        this.ionoDataDiagram = null;
    } else {
        this.ionoDataDiagram = new IonoDataDiagram(probeData);
    }

    this.canvasMain = mainCanvas;
    this.contextMain = mainCanvas.getContext("2d");
    this.width = mainCanvas.width;
    this.height = mainCanvas.height;

    this.canvasBuffer = document.createElement("canvas");
    this.contextBuffer = this.canvasBuffer.getContext("2d");
    this.canvasBuffer.width = this.width;
    this.canvasBuffer.height = this.height;
    this.canvasStatic = document.createElement("canvas");
    this.contextStatic = this.canvasStatic.getContext("2d");
    this.canvasStatic.width = this.width;
    this.canvasStatic.height = this.height;

    this.mouseX = 0;
    this.mouseY = 0;

    this.CFAR_SW = false;
    this.clip_value = 0;

    this.diagram = {
        width: 800,
        height: 500,
        axis: {xLen: 450, yLen: 700},
        coordinateOrigin: {x: 50, y: 550, lineWidth: 2},
        tag: {width: 40, height: 25},
        tip: {width: 50, height: 25, radius: 5},
        lineWidth: 2,
        scaleLength: 5,
        lineOffset: 0.5,
        legend: {width: 35, height: 300, x: this.width - 100, y: 150, fontSize: 12},
        title: {text: "123", fontSize: 20, x: this.width / 2, y: 30}
    };

    this.drawDynamic = function (leftStr, bottomStr, tipStr, tipC) {
        this.clearContext(this.contextBuffer);

        //----------------------------------------- tag
        {
            let X0 = this.diagram.coordinateOrigin.x - this.diagram.tag.width;
            let Y0 = this.mouseY - this.diagram.tag.height / 2;
            let X1 = this.mouseX - this.diagram.tag.width / 2;
            let Y1 = this.diagram.coordinateOrigin.y;

            this.contextBuffer.fillStyle = "rgba(33,33,33,0.5)";
            this.contextBuffer.fillRect(X0, Y0, this.diagram.tag.width, this.diagram.tag.height);
            this.contextBuffer.fillRect(X1, Y1, this.diagram.tag.width, this.diagram.tag.height);

            //----------------------------------------- tag text

            this.contextBuffer.font = "12px Arial";
            this.contextBuffer.fillStyle = "#FFFFFF";
            this.contextBuffer.textAlign = "center";
            this.contextBuffer.textBaseline = "middle";
            this.contextBuffer.fillText(leftStr, X0 + this.diagram.tag.width / 2, this.mouseY);
            this.contextBuffer.fillText(bottomStr, this.mouseX, Y1 + this.diagram.tag.height / 2);
        }

        //----------------------------------------- line
        {
            this.contextBuffer.beginPath();
            this.contextBuffer.strokeStyle = "#ffffff";
            this.contextBuffer.lineWidth = this.diagram.lineWidth;
            this.contextBuffer.setLineDash([0]);
            let lineOffset = this.diagram.lineOffset;
            let X = {x0: this.diagram.coordinateOrigin.x, y0: this.mouseY - lineOffset, x1: this.diagram.coordinateOrigin.x + this.diagram.width, y1: this.mouseY - lineOffset};
            let Y = {x0: this.mouseX - lineOffset, y0: this.diagram.coordinateOrigin.y, x1: this.mouseX - lineOffset, y1: this.diagram.coordinateOrigin.y - this.diagram.height};
            this.contextBuffer.moveTo(Y.x0, Y.y0);
            this.contextBuffer.lineTo(Y.x1, Y.y1);
            this.contextBuffer.moveTo(X.x0, X.y0);
            this.contextBuffer.lineTo(X.x1, X.y1);
            this.contextBuffer.stroke();
        }

        //----------------------------------------- tip
        {
            let offset = 10;
            let x = this.mouseX + offset;
            let y = this.mouseY + offset;
            if (this.mouseX > this.diagram.coordinateOrigin.x + this.diagram.width / 2) {
                x = this.mouseX - this.diagram.tip.width - offset;
            }

            if (this.mouseY > this.diagram.coordinateOrigin.y - this.diagram.height / 2) {
                y = this.mouseY - this.diagram.tip.height - offset;
            }
            this.contextBuffer.fillStyle = "rgba(150,72,134,0.7)";
            this.contextBuffer.fillRect(x, y, this.diagram.tip.width, this.diagram.tip.height);


            //----------------------------------------- tip text

            this.contextBuffer.font = "12px Arial";
            this.contextBuffer.fillStyle = "#FFFFFF";
            this.contextBuffer.textAlign = "left";
            this.contextBuffer.textBaseline = "middle";
            this.contextBuffer.fillText(tipStr, x + this.diagram.tip.width / 2, y + this.diagram.tip.height / 2);


            //----------------------------------------- color

            let r = HSV(tipC, -0.125);
            let g = HSV(tipC, 0.125);
            let b = HSV(tipC, 0.375);
            //this.contextBuffer.strokeStyle = "hsl(" + c + ", 100%, 50%)";
            this.contextBuffer.fillStyle = "rgb(" + r + "," + g + "," + b + ")";
            this.contextBuffer.beginPath();
            this.contextBuffer.arc(x + this.diagram.tip.radius + 5, y + this.diagram.tip.height / 2, this.diagram.tip.radius, 0, 2 * Math.PI);
            this.contextBuffer.closePath();
            this.contextBuffer.fill();
        }

    };

    this.drawStatic = function () {
        this.clearContext(this.contextStatic);

        //------------------------------- background
        {
            this.contextStatic.fillStyle = "#f2f2f2";
            this.contextStatic.fillRect(0, 0, this.width, this.height);
        }

        //------------------------------- ionoDataDiagram
        {
            let w = this.ionoDataDiagram.width;
            let h = this.ionoDataDiagram.height;
            let x = this.diagram.coordinateOrigin.x;
            let y = this.diagram.coordinateOrigin.y - this.diagram.height;
            let sw = this.diagram.width;
            let sh = this.diagram.height;
            this.contextStatic.drawImage(this.ionoDataDiagram.canvasDiagram, 0, 0, w, h, x, y, sw, sh);
        }

        //------------------------------- coordinate
        {
            this.contextStatic.beginPath();
            this.contextStatic.strokeStyle = "#333333";
            this.contextStatic.lineWidth = this.diagram.coordinateOrigin.lineWidth;
            this.contextStatic.setLineDash([0]);
            this.contextStatic.lineJoin = "miter";
            this.contextStatic.moveTo(this.diagram.coordinateOrigin.x, this.diagram.coordinateOrigin.y - this.diagram.height);
            this.contextStatic.lineTo(this.diagram.coordinateOrigin.x, this.diagram.coordinateOrigin.y);
            this.contextStatic.lineTo(this.diagram.coordinateOrigin.x + this.diagram.width, this.diagram.coordinateOrigin.y);
            this.contextStatic.stroke();

            this.contextStatic.strokeStyle = "#000000";
            this.contextStatic.lineWidth = this.diagram.lineWidth;
            this.contextStatic.setLineDash([0]);
            this.contextStatic.lineJoin = "miter";

            for (let x = 0; x < this.diagram.width; x += parseInt(this.diagram.width / 10)) {
                let rx = parseInt(MAP(x, 0, this.diagram.width, 0, this.diagram.width) + this.diagram.coordinateOrigin.x);
                this.contextStatic.beginPath();
                this.contextStatic.moveTo(rx, this.diagram.coordinateOrigin.y);
                this.contextStatic.lineTo(rx, this.diagram.coordinateOrigin.y + this.diagram.scaleLength);
                this.contextStatic.stroke();
            }

            for (let y = 0; y < this.diagram.height; y += parseInt(this.diagram.height / 10)) {
                let ry = parseInt(this.diagram.coordinateOrigin.y - MAP(y, 0, this.diagram.height, 0, this.diagram.height));
                this.contextStatic.beginPath();
                this.contextStatic.moveTo(this.diagram.coordinateOrigin.x - this.diagram.scaleLength, ry);
                this.contextStatic.lineTo(this.diagram.coordinateOrigin.x, ry);
                this.contextStatic.stroke();
            }
        }

        //------------------------------- legend
        {
            this.contextStatic.fillStyle = "#333333";
            this.contextStatic.fillRect(this.diagram.legend.x, this.diagram.legend.y, this.diagram.legend.width, this.diagram.legend.height);

            this.contextStatic.setLineDash([0]);
            this.contextStatic.lineWidth = 2;


            let span = parseInt((this.ionoDataDiagram.max - this.ionoDataDiagram.min));
            for (let y = this.diagram.legend.y; y <= this.diagram.legend.y + this.diagram.legend.height; y += 2) {
                this.contextStatic.beginPath();
                let c = ((y - this.diagram.legend.y) / this.diagram.legend.height);
                let r = HSV(c, -0.125);
                let g = HSV(c, 0.125);
                let b = HSV(c, 0.375);
                //this.contextBuffer.strokeStyle = "hsl(" + c + ", 100%, 50%)";
                this.contextStatic.strokeStyle = "rgb(" + r + "," + g + "," + b + ")";
                this.contextStatic.moveTo(this.diagram.legend.x, y);
                this.contextStatic.lineTo(this.diagram.legend.x + this.diagram.legend.width, y);
                this.contextStatic.stroke();


                if ((y - this.diagram.legend.y) % parseInt(this.diagram.legend.height / 5) === 0) {

                    this.contextStatic.beginPath();
                    this.contextStatic.moveTo(this.diagram.legend.width + this.diagram.legend.x, y);
                    this.contextStatic.lineTo(this.diagram.legend.width + this.diagram.legend.x + 8, y - 3);
                    this.contextStatic.lineTo(this.diagram.legend.width + this.diagram.legend.x + 8, y + 3);
                    this.contextStatic.closePath();
                    this.contextStatic.fillStyle = "#242424";
                    this.contextStatic.fill(); //�պ���״��������䷽ʽ���Ƴ���

                    this.contextStatic.font = this.diagram.legend.fontSize + "px Arial";
                    this.contextStatic.fillStyle = "#242424";
                    this.contextStatic.textAlign = "left";
                    this.contextStatic.textBaseline = "middle";
                    val_text = parseInt(this.ionoDataDiagram.max - c * span);
                    this.contextStatic.fillText(val_text, this.diagram.legend.x + this.diagram.legend.width + 10, y);
                }

            }
        }

        //------------------------------- title
        {
            this.contextStatic.font = this.diagram.title.fontSize + "px Arial";
            this.contextStatic.fillStyle = "#242424";
            this.contextStatic.textAlign = "center";
            this.contextStatic.textBaseline = "middle";
            this.contextStatic.fillText(this.diagram.title.text, this.diagram.title.x, this.diagram.title.y);
        }
    };

    this.appendLayer = function (canvas, x, y) {
        this.contextMain.drawImage(canvas, x, y);
    };

    this.clearContext = function (context) {
        context.clearRect(0, 0, this.width, this.width);
    };

    this.scalePoint = function (x, y, w, h, sw, sh) {
        let sx = parseInt(x * sw / w);
        let sy = parseInt(y * sh / h);
        return [sx, sy];
    };

    this.mouseMoveFun = function () {
        this.clearContext(this.contextMain);
        this.appendLayer(this.canvasStatic, 0, 0);
        if (this.isDiagramZone(this.mouseX, this.mouseY)) {
            let point = this.scalePoint(this.mouseX - this.diagram.coordinateOrigin.x, this.mouseY - this.diagram.coordinateOrigin.y, this.diagram.width, this.diagram.height, this.ionoDataDiagram.width, this.ionoDataDiagram.height);
            let val = this.ionoDataDiagram.processedData[this.ionoDataDiagram.height + point[1] - 1][point[0]];
            let valC = 1 - this.ionoDataDiagram.hsvAmpData[this.ionoDataDiagram.height + point[1] - 1][point[0]];
            this.drawDynamic(-point[1], point[0], val, valC);
            this.appendLayer(this.canvasBuffer, 0, 0);
        }

    };

    this.isDiagramZone = function (x, y) {
        return (x > this.diagram.coordinateOrigin.x && x < this.diagram.coordinateOrigin.x + this.diagram.width
            && y > this.diagram.coordinateOrigin.y - this.diagram.height && y < this.diagram.coordinateOrigin.y);
    };

    this.drawALL = function () {
        this.ionoDataDiagram.drawProcessedImage(this.CFAR_SW, this.clip_value);
        this.drawStatic();
        this.mouseMoveFun();
    }


}

function IonoDataDiagram(probeData) {
    this.probeData = probeData;
    this.max = 0;
    this.min = 0;
    this.width = 0;
    this.height = 0;
    this.ampData = 0;
    this.hsvAmpData = null;
    this.processedData = null;
    this.average = null;

    this.canvasDiagram = document.createElement("canvas");
    this.contextDiagram = this.canvasDiagram.getContext("2d");

    this.diagramImageData = null;
    this.diagramImage = new Image();

    this.toHsvAmpData = function (imgData) {
        this.max = getMax(imgData);
        this.min = getMin(imgData);
        for (let h = 0; h < this.height; h++) {
            for (let w = 0; w < this.width; w++) {
                this.hsvAmpData[h][w] = MAP(imgData[h][w], this.min, this.max, 0, 1);
            }
        }
    };

    this.drawIonoDiagram = function () {
        let i = 0;
        let val = 0;
        for (let h = 0; h < this.height; h++) {
            for (let w = 0; w < this.width; w++) {
                i = (h * this.width + w) * 4;
                val = 1 - this.hsvAmpData[h][w];
                this.diagramImageData.data[i] = HSV(val, -0.125);
                this.diagramImageData.data[i + 1] = HSV(val, 0.125);
                this.diagramImageData.data[i + 2] = HSV(val, 0.375);
                this.diagramImageData.data[i + 3] = 255;
            }
        }
        this.contextDiagram.putImageData(this.diagramImageData, 0, 0);
    };

    this.drawOriginalImage = function () {
        this.toHsvAmpData(this.ampData);
        this.drawIonoDiagram();
    };

    this.drawProcessedImage = function (filter_sw, bottom) {
        this.processDate(filter_sw, bottom);
        this.toHsvAmpData(this.processedData);
        this.drawIonoDiagram();
    };

    this.processDate = function (filter_sw, bottom) {
        for (let h = 0; h < this.height; h++) {
            for (let w = 0; w < this.width; w++) {
                if (h < this.height - bottom) {
                    this.processedData[h][w] = this.ampData[h][w] - (filter_sw ? this.average[w] : 0);
                }
                else {
                    this.processedData[h][w] = parseInt(Math.random() * 8 - 4);
                }
            }
        }
    };

    this.getAverage = function (top) {
        for (let w = 0; w < this.width; w++) {
            let sum = 0;
            for (let h = 0; h < top; h++) {
                sum += this.ampData[h][w];
            }
            this.average[w] = parseInt(sum / top);
        }
    };

    this.toImage = function () {
        this.diagramImage.src = this.canvasDiagram.toDataURL("image/jpg");
    };

    this.init = function () {
        if (probeData !== null) {
            this.probeData = probeData;
            this.max = 0;
            this.min = 0;
            this.width = probeData.width;
            this.height = probeData.height;
            this.ampData = probeData.data;
            this.hsvAmpData = createArray(probeData.width, probeData.height);
            this.processedData = createArray(probeData.width, probeData.height);
            this.average = new Array(this.width);
            this.canvasDiagram.width = this.width;
            this.canvasDiagram.height = this.height;
            this.diagramImageData = this.contextDiagram.createImageData(this.width, this.height);
        }
        this.getAverage(40);
    }
}

function ProbeData() {
    this.deviceId = "";
    //this.location = "";
    this.type = "";
    this.date = "";
    this.time = "";

    this.freq_start = 0;
    this.freq_step = 0;
    this.freq_end = 0;
    //this.longitude = "";
    //this.latitude = "";

    this.codes = [C16ACode, C16BCode];
    this.codeId = null;
    this.PSN = 0;
    this.RMAX = 0;
    this.data = null;
    this.rawData = null;

    this.width = 0;
    this.height = 0;

    this.init = function (dataJson) {
        this.deviceId = dataJson.deviceId;
        this.type = dataJson.type;
        this.date = dataJson.date;
        this.time = dataJson.time;

        this.freq_start = dataJson.freq_start;
        this.freq_step = dataJson.freq_step;
        this.freq_end = dataJson.freq_end;

        this.PSN = dataJson.PSN;
        this.codeId = dataJson.codeId;

        if (!dataJson.transposed) {
            this.data = transpose(dataJson.data);
        }
        else {
            this.data = dataJson.data;
        }

        this.width = this.data[0].length;
        this.height = this.data.length;
        this.RMAX = this.width;

    };

    this.readFromLocal = function (file) {
        let fileInfo = getFIleInfo(file.name);
        this.type = fileInfo.ext;
        this.dataInfo = fileInfo;
        this.date = fileInfo.date;
        this.time = fileInfo.time;
        this.codes = [C16ACode, C16BCode];
        this.location = [fileInfo.latitude, fileInfo.longitude];
        this.PSN = fileInfo.PSN;
        this.longitude = fileInfo.longitude;
        this.latitude = fileInfo.latitude;

        if (fileInfo.ext === "SOS") {
            this.width = fileInfo.PSN;
            this.height = fileInfo.covLen;
            this.freq_start = fileInfo.frequency;
            this.freq_step = 0;
            this.freq_end = 0;
        }
        else if (fileInfo.ext === "COS") {
            this.width = fileInfo.freqSpan;
            this.height = fileInfo.covLen;
            this.freq_start = fileInfo.freqStart;
            this.freq_step = fileInfo.freqStep;
            this.freq_end = fileInfo.freqEnd;
            this.cosToAmp_CC(this.rawData, fileInfo);
        }
        else if (fileInfo.ext === "AMP") {

        }


    };

    this.cosToAmp_CC = function (data, fileInfo) {
        this.process = 0;
        let freqSpan = fileInfo.freqSpan;
        let covLen = fileInfo.covLen;
        let PSN = fileInfo.PSN;
        let RMAX = fileInfo.RMAX;
        let codeLen = fileInfo.codeLen;


        let ampDataTemp = new Array(freqSpan * covLen);
        let tempData = new Array(covLen * 4);

        let oneFrequency = RMAX * PSN * 4;
        let temp = 0;

        let C16ACode = this.codes[0];
        let C16BCode = this.codes[1];

        let Ar = 0;
        let Ai = 0;
        let Br = 0;
        let Bi = 0;
        // ���
        for (let f = 0; f < freqSpan; f++) {
            tempData.fill(0);
            this.process = parseInt(f / freqSpan * 100);
            for (let i = 0; i < PSN; i++) {
                for (let j = 0; j < covLen; j++) {
                    Ar = 0;
                    Ai = 0;
                    Br = 0;
                    Bi = 0;
                    for (let k = 0; k < codeLen; k++) {
                        let index = oneFrequency * f + RMAX * 4 * i + j * 2 + k * 2;
                        Ar += C16ACode[k] * data[index];
                        Ai += C16ACode[k] * data[index + 1];
                        Br += C16BCode[k] * data[index + RMAX * 2];
                        Bi += C16BCode[k] * data[index + RMAX * 2 + 1];
                    }

                    temp = Math.sqrt((Ar + Br) * (Ar + Br) + (Ai + Bi) * (Ai + Bi)); // 20log10{[(A+B)^2 + (Ai+Bi)^2]^1/2}
                    tempData[j] += temp < 0 ? 0 : temp;
                }
            }
            for (let j = 0; j < covLen; j++) {
                ampDataTemp[f * covLen + j] = 20 * Math.log10(tempData[j] / PSN);
            }
        }

        this.data = new Array(freqSpan);
        for (let c = 0; c < covLen; c++) {
            this.data[c] = new Array(freqSpan);
            for (let f = 0; f < freqSpan; f++) {
                this.data[c][f] = parseInt(ampDataTemp[(covLen - c - 1) + covLen * f]);
            }
        }
    };

    this.sosToAmp_CC = function (data, fileInfo) {
        this.process = 0;
        let covLen = fileInfo.covLen;
        let PSN = fileInfo.PSN;
        let RMAX = fileInfo.RMAX;
        let codeLen = fileInfo.codeLen;
        let ampDataTemp = new Array(freqSpan * covLen);
        let tempData = new Array(covLen * 4);

        let temp = 0;

        let C16ACode = this.codes[0];
        let C16BCode = this.codes[1];

        let Ar = 0;
        let Ai = 0;
        let Br = 0;
        let Bi = 0;
        tempData.fill(0);
        this.process = parseInt(f / freqSpan * 100);
        for (let i = 0; i < PSN; i++) {
            for (let j = 0; j < covLen; j++) {
                Ar = 0;
                Ai = 0;
                Br = 0;
                Bi = 0;
                for (let k = 0; k < codeLen; k++) {
                    let index = RMAX * 4 * i + j * 2 + k * 2;
                    Ar += C16ACode[k] * data[index];
                    Ai += C16ACode[k] * data[index + 1];
                    Br += C16BCode[k] * data[index + RMAX * 2];
                    Bi += C16BCode[k] * data[index + RMAX * 2 + 1];
                }

                temp = Math.sqrt((Ar + Br) * (Ar + Br) + (Ai + Bi) * (Ai + Bi)); // 20log10{[(A+B)^2 + (Ai+Bi)^2]^1/2}
                tempData[j] += temp < 0 ? 0 : temp;
            }
        }
        for (let j = 0; j < covLen; j++) {
            ampDataTemp[f * covLen + j] = 20 * Math.log10(tempData[j] / PSN);
        }


        this.data = new Array(freqSpan);
        for (let c = 0; c < covLen; c++) {
            this.data[c] = new Array(freqSpan);
            for (let f = 0; f < freqSpan; f++) {
                this.data[c][f] = parseInt(ampDataTemp[(covLen - c - 1) + covLen * f]);
            }
        }
    };
}