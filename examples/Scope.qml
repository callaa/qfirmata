import QtQuick 2.5

Canvas {
	id: canvas

	property color background: "#000000"
	property color foreground: "#27ae60"
	property int bufferSize: 100

	Component.onCompleted: {
		internal.resizeBuffer(bufferSize);
	}

	onBufferSizeChanged: {
		internal.resizeBuffer(bufferSize);
	}

	onPaint: {
		var ctx = canvas.getContext('2d');
		var i = internal.pos;
		var yscale = (canvas.height-1);
		var xscale = canvas.width / internal.samples.length

		ctx.fillStyle = canvas.background;
		ctx.strokeStyle = canvas.foreground;

		ctx.fillRect(0, 0, canvas.width, canvas.height);
		ctx.beginPath();

		ctx.moveTo(0, canvas.height - 1 - (yscale * internal.samples[0]));
		for(var x=1;x<internal.pos;++x) {
			ctx.lineTo(x * xscale, canvas.height - 1 - (yscale * internal.samples[x]));
		}
		ctx.moveTo(x * xscale, 0);
		ctx.lineTo(x * xscale, canvas.height);

		ctx.moveTo(internal.pos * xscale, canvas.height - 1 - (yscale * internal.samples[internal.pos]));
		for(var x=internal.pos + 1;x<internal.samples.length;++x) {
			ctx.lineTo(x * xscale, canvas.height - 1 - (yscale * internal.samples[x]));
		}

		ctx.stroke();
	}

	function addSample(sample) {
		internal.samples[internal.pos] = sample;
		internal.pos = (internal.pos + 1) % internal.samples.length;
		requestPaint();
	}

	QtObject {
		id: internal

		property variant samples
		property int pos

		function resizeBuffer(len) {
			if(samples == null || len != samples.length) {
				console.log("Resetting ring buffer size to", len);
				samples = []
				for(var i=0;i<len;++i) {
					samples.push(0)
				}
				pos = 0
			}
		}
	}
}

