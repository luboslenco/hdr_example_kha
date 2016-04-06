package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Assets;
import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexData;
import kha.graphics4.ConstantLocation;

class Empty {

	var hdrPipeline:PipelineState;
	var exposureID:ConstantLocation;
	var exposure = 1.0;
	var mult = 1.0;

	var delta = 0.0;
	var last = 0.0;

	public function new() {
		Assets.loadEverything(loadingFinished);
	}

	function loadingFinished() {
		var structure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float3);
		structure.add("texPosition", VertexData.Float2);
		structure.add("vertexColor", VertexData.Float4);

		hdrPipeline = new PipelineState();
		hdrPipeline.inputLayout = [structure];
		hdrPipeline.fragmentShader = Shaders.hdr_frag;
		hdrPipeline.vertexShader = Shaders.painter_image_vert;
		hdrPipeline.compile();

		exposureID = hdrPipeline.getConstantLocation("exposure");

		last = Scheduler.time();
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
	}

	function update(): Void {
		exposure += delta * 1.5 * mult;
		if (exposure >= 8 || exposure <= 0) mult *= -1;

		delta = Scheduler.time() - last;
		last = Scheduler.time();
	}

	function render(framebuffer: Framebuffer): Void {
		var g2 = framebuffer.g2;
		var g4 = framebuffer.g4;
		g2.pipeline = hdrPipeline;
		g4.setFloat(exposureID, exposure);

		g2.begin();
		g2.drawImage(Assets.images.shrine, 0, 0);	
		g2.end();
	}
}
