/**
 * Created by oHa on 2018/1/25.
 */

var ArjMap = window.ArjMap = {};
ArjMap.Map = function(params) {
	this.id = params.id;// 容器ID
	this.baseUrl = params.baseUrl || {
		'name' : ' ',
		'url' : '',
		'isShow' : true
	};// 地图--底图
	this.urlArr = params.urlArr || '';// 地图---数组
	this.center = params.centerCoordinate || '';// 地图中心点[经度,纬度]
	this.zoom = params.zoom || ''; // 地图加载级别
	this.maxZoom = params.maxZoom || ''; // 最大放大级别
	this.minZoom = params.minZoom || ''; // 最小缩放级别
	this.zoomShowOrHide = params.zoomShowOrHide || false; // 右上角地图+-控制
	// this.showOLpage = params.showOLpage||false;
	this.map = null;
	//this.view = null;
	this.content = null;
	this.overlayDialog = null;

	// 标注容器
	this.geoStrDraw = null; // 当前绘制图形的坐标串
	this.areaPointDraw = '';
	this.areaMapDraw = '';
	this.currentFeatureDraw = null; // 当前绘制的几何要素
   
	this.colorArr1 = [ {
		"color" : "#aa4644",
		"rgba" : "rgba(170,70,68,0)"
	}, {
		"color" : "#4573a7",
		"rgba" : "rgba(69,115,167,0)"
	}, {
		"color" : "#89a54e",
		"rgba" : "rgba(137,165,78,0)"
	}, {
		"color" : "#71588f",
		"rgba" : "rgba(113,88,143,0)"
	}, {
		"color" : "#4298af",
		"rgba" : "rgba(66,152,175,0)"
	}, {
		"color" : "#db843d",
		"rgba" : "rgba(219,132,61,0)"
	}, {
		"color" : "#93a9d0",
		"rgba" : "rgba(147,169,206,0)"
	}, {
		"color" : "#d09392",
		"rgba" : "rgba(208,147,146,0)"
	}, {
		"color" : "#b9ce96",
		"rgba" : "rgba(185,206,150,0)"
	}, {
		"color" : "#a99bbc",
		"rgba" : "rgba(169,155,188,0)"
	}, {
		"color" : "#92c3d4",
		"rgba" : "rgba(146,195,212,0)"
	}, {
		"color" : "#ffdf5f",
		"rgba" : "rgba(255,223,95,0)"
	}]
	
	
/*	this.colorArr = [ {
		"color" : "#c985fe",
		"rgba" : "rgba(201,133,254,0.8)"
	}, {
		"color" : "#7ae7b2",
		"rgba" : "rgba(122,231,178,0.8)"
	}, {
		"color" : "#5db0fd",
		"rgba" : "rgba(93,176,253,0.8)"
	}, {
		"color" : "#e1e8b2",
		"rgba" : "rgba(225,232,178,0.8)"
	}]
}*/
	this.colorArr = [ {
		"color" : "rgba(201,133,254,0.8)",
		"rgba" : "rgba(201,133,254,0.8)"
	}, {
		"color" : "rgba(122,231,178,0.8)",
		"rgba" : "rgba(122,231,178,0.8)"
	}, {
		"color" : "rgba(93,176,253,0.8)",
		"rgba" : "rgba(93,176,253,0.8)"
	}, {
		"color" : "rgba(225,232,178,0.8)",
		"rgba" : "rgba(225,232,178,0.8)"
	}]
}

/**
 * 加载地图
 */

ArjMap.Map.prototype={
		//初始化
		init:function(){
			//初始化题图地图
			this.map= this.drawMap();
			
			//鼠标悬上选中图层样式
//			this.addInteractionHover();
			
			//鹰眼图
//			if (this.overviewmap) {
//				this.overviewMap();
//			};
			
			//自定义放大缩小方向控件
			this.addPanZoomBar();
		},
		//地图底图数据图层
		baseUrlTypeLayers:function(){
			var baseUrl = this.baseUrl;
			var layers=[];
		    var len=baseUrl.length;
		    if(len>0){
		    	 for(var i=0;i<len;i++){
		    			//地图瓦片类型判断
		    		 var id=baseUrl[i].id;
		    		 var type=baseUrl[i].type;
		    		 if(typeof (type)!="undefined"){
		    			switch (type) {
		    			//杭州道现场地图
		    			  case '1':
		    				this[id+'Tile']=new ol.layer.Tile({
				                     title : "地图",
				                     opacity:1,//透明度
				                     name : baseUrl[i].name,//名称
				                     visible : baseUrl[i].isShow,//显示隐藏
				                     source : new ol.source.XYZ({
				                         tileGrid: new ol.tilegrid.TileGrid({
				                             tileSize:baseUrl[i].tileSize,//瓦片大小
				                             origin: baseUrl[i].origin, // 原点  
				                             resolutions: baseUrl[i].resolutions//分辨率
	
				                         }),
				                         url : baseUrl[i].url,//地址
				                         projection : 'EPSG:4326'
				                     })
				                 });
						        break;
						      //天地地图
						    case '2':
						    	this[id+'Tile']=new ol.layer.Tile({
				                      title : "地图",
				                      name : baseUrl[i].name,
				                      visible : baseUrl[i].isShow,
				                      source : new ol.source.XYZ({
				                          url : baseUrl[i].url,
				                      })
				                  });
						        break;
						    default:
						}
		    			layers.push(this[id+'Tile'])
					 }
		    	 }
		    }
		    return layers
			
		},
		//创建视图
		view:function(){
			var view= new ol.View({
				center : this.center,//中心位置
				zoom : this.zoom,//当前层级
				minZoom : this.minZoom,//最小层级
				maxZoom : this.maxZoom,//最大层级
				projection : 'EPSG:4326'
			});
			return view;
		},
    	//创建地图
		drawMap:function(){
			var map=new ol.Map({
				layers : this.baseUrlTypeLayers(),
				view : this.view(),
				target : this.id,//地图容器id
				controls : ol.control.defaults({
					zoom : this.zoomShowOrHide,//图层放大缩小控件是否显示
				})
			});
			return map;
		},
		//加载GeoJSON数据
		vectorGeoJSON:function(data){
			var  vector =  new ol.source.Vector({
					format : new ol.format.GeoJSON(),
					features : (new ol.format.GeoJSON()).readFeatures(data)	
				});
			 return vector;
		},
		//点聚合
		cluster:function(source){
			  var  cluster = new ol.source.Cluster({
					distance: 20,
					source: source,
					geometryFunction:function(feature) {
						if(feature.getGeometry().getType()=="Point"){
							return feature.getGeometry();
						}else {
							return null;
						}
					}
			 });
			 return cluster
			 
		},
		//图层样式
		featureStyles:function(variable,feature){
		   var map=this.map;
		   var colorArr = this.colorArr;
		   var index = Math.floor((Math.random() * colorArr.length));
		   var fillColor = colorArr[index].rgba;
		   var color = colorArr[index].color;
		   var styles = {
			  
			    };
			   return styles;
		},
		
		//图层显示隐藏
		layersIsShow:function(type, isShow) {
			var map = this.map;
			var layer = this[type];
			if (layer) {
				layer.setVisible(isShow);
			}
		},
		//自定义放大缩小方向控件
		addPanZoomBar:function(){
			var map=this.map;
			var _this=this;
			var view=map.getView();
		    var high_top1, high_top2;
		    if($("#PanZoomBar").length>0){
		    	 $("#PanZoomBar").draggable({
		    		 axis:"y",
		    		 containment:"#ControlPanZoomBar",
		    		 start: function(e1) {
		    			 high_top1 = parseInt(document.getElementById("PanZoomBar").style.top);
		    		 },
		    		 stop: function(e2) {
			    		 high_top2= parseInt(document.getElementById("PanZoomBar").style.top);
			    			// 此处的_this.maxZoom为地图最大的放大级数，250代替滑块150的为滑块轴的高度，16位滑块的高度单位为px,对计算出来的小数向上取整
			    		 var realzoom = Number(_this.maxZoom)- Number(_this.maxZoom) * high_top2 / (303 - 16);
			    		    // 设置view zoom值
			    		 view.setZoom(realzoom);
		    		 }
	    		 });
	    	    // view上绑定zoom改变事件
	    	    view.on('change:resolution', function (e) {
		    	    var zommleve = view.getZoom();
		    	    // 此处的_this.maxZoom为地图最大的放大级数，用210代替110为滑块轴的高度，16位滑块的高度
		    	    var high =(Number(_this.maxZoom) - zommleve) * (303 - 16) / Number(_this.maxZoom);
		    	    document.getElementById("PanZoomBar").style.top = high+"px"
	    	    });
		    }
		},
		//定位到某一坐标位置
		goTo:function(point) {
			var map = this.map;
			var view = map.getView();
			//坐标
			var centpoint = point || this.center;
			//动画300ms定位将坐标设为中心点
			 view.animate({
				 center: centpoint,
		         duration: 300
		       });
		},
		//地图切换-影像图和普通地图相互切换
		switchMap:function(){
			var map=this.map;
			var baseUrl = this.baseUrl;
			var len=baseUrl.length;
			
			if(len>0){
				for(var i=0;i<len;i++){
					var id=baseUrl[i].id;
					//设置底图图层显示隐藏
					this[id+'Tile'].setVisible(!this[id+'Tile'].getVisible())
					}
				}
		},
	    //缩放控件--放大、缩小
		zoomInOut:function(type){
			var map=this.map;
			var view=map.getView();
			var zoom=view.getZoom();
			if(type=='in'){
				zoom=zoom+0.5;
			}else if(type=='out'){
				zoom=zoom-0.5;
			}
			 view.animate({
				 zoom: zoom,
		         duration: 300
		       });
		},
        //地图平移
		panDirection:function(direction){
			var map=this.map;
			var view=map.getView();
			var lonlat = 0.06;// 平移系数
			var mapCenter =ol.proj.fromLonLat( view.getCenter());// 转化为投影坐标
		    switch (direction) {
		        case "north":
		            mapCenter[1] += lonlat * Math.pow(2, 30 - view.getZoom());
		            break;
		        case "south":
		            mapCenter[1] -= lonlat * Math.pow(2, 30 - view.getZoom());
		            break;
		        case "west":
		            mapCenter[0] -= lonlat * Math.pow(2, 30 - view.getZoom());
		            break;
		        case "east":
		            mapCenter[0] += lonlat * Math.pow(2, 30 - view.getZoom());
		            break;
		    }
		    
		    // 更改center 实现地图平移--动画
		    view.animate({
		          center: ol.proj.toLonLat(mapCenter),
		          duration: 300
		        });
		   // 转化为经纬度坐标
		   // view.setCenter(ol.proj.toLonLat(mapCenter));
		   // 地图渲染
		    map.render();	 
		},
		//事件动画
		postcomposeOl:function(name, coordinate, id, obj,happenDate) {
			this.postcomposeOlName = name;
			this.postcomposeOlCoordinate = coordinate;
			this.postcomposeOlId = id;
			this.postcomposeOlObj = obj;
			this.happenDate = (happenDate == null ? '' : happenDate)
			var map = this.map;
			this.addEventOverlayLabel(name, coordinate,id);
			//创建矢量图层
			var layer = new ol.layer.Vector({
				source : new ol.source.Vector(),
				zIndex:9
			})
			map.addLayer(layer);
			this.goTo(coordinate);//定位到中心
			var circle = new ol.Feature({
				geometry : new ol.geom.Point(coordinate),
				name : 'EventFeature',
				id : id
			});
			circle.setStyle(new ol.style.Style({
				image : new ol.style.Circle({
					radius : 0,
					stroke : new ol.style.Stroke({
						color : 'red',
						size : 1
					}),
					fill : new ol.style.Fill({
						color : 'red'
					}),
				})

			}));
			layer.getSource().addFeature(circle);
           
			// 关键的地方在此：监听postcompose事件，在里面重新设置circle的样式
			var radius = 0;
			map.on('postcompose', function() {
				// 增大半径，最大20
				radius++;
				radius = radius % 60;
				// 设置样式
				circle.setStyle(new ol.style.Style({
					image : new ol.style.Circle({
						radius : radius/2,
						snapToPixel: false,
						fill: new ol.style.Fill({
			                 color: 'red'
						}),
						stroke: new ol.style.Stroke({
			                 color: 'red',
			                 size: 1,
			                 width: 3 
						})
					})
				}));
			})
		},
		// 图层叠加及管理
		layersControl: function(id) {
			var map = this.map;
			var layer = []; // map中的图层数组
			var layerName = []; // 图层名称数组
			var layerVisibility = []; // 图层可见属性数组
			var treeContent = document.getElementById(id); // 图层目录容器
			var layers = map.getLayers(); // 获取地图中所有图层
			for (var i = 0; i < layers.getLength(); i++) {
				// 获取每个图层的名称、是否可见属性
				layer[i] = layers.item(i);
				layerName[i] = layer[i].get('name');
				layerVisibility[i] = layer[i].getVisible();
				// 新增li元素，用来承载图层项
				var elementLi = document.createElement('li');
				treeContent.appendChild(elementLi); // 添加子节点
				// 创建复选框元素
				var elementInput = document.createElement('input');
				elementInput.type = "checkbox";
				elementInput.name = "layers";
				elementLi.appendChild(elementInput);
				// 创建label元素
				var elementLable = document.createElement('label');
				elementLable.className = "layer";
				// 设置图层名称
				if (typeof elementLable.textContent == "string") {
					elementLable.textContent = layerName[i];
				} else {
					elementLable.innerText = layerName[i];
				}
				elementLi.appendChild(elementLable);
				// 设置图层默认显示状态
				if (layerVisibility[i]) {
					elementInput.checked = true;
				}
				// 为checkbox添加变更事件
				addChangeEvent(elementInput, layer[i]);
				function addChangeEvent(element, layer) {
					element.onclick = function() {
						if (element.checked) {
							// 显示图层
							layer.setVisible(true); 
						} else {
							// 不显示图层
							layer.setVisible(false); 
						}

					};
				}
			}
		},
		// 删除图层
		removeLayer:function(type) {
			var map = this.map;
			var layer = this[type]
			if (layer) {
				// 获取地图中所有图层
				var layers = map.getLayers(); 
				var len = layers.getLength();
				
//				var selectFeatures = layer.getSource().getFeatures();
//				for ( var i in selectFeatures) {
//					map.removeOverlay(this[(selectFeatures[i].get('name') + 'Overlay')])
//				}
				map.removeLayer(layer)
			}
		},
		//清空图层
		clearOverlays : function() {
			var map = this.map;
			map.getOverlays().clear();
			map.addOverlay(this.overlayDialog)
			if (this.postcomposeOlId != null && this.postcomposeOlId != '') {
				this.addOverlayLabel(this.postcomposeOlName,this.postcomposeOlCoordinate)
			}
		},
		//地图全屏
		fullScreen:function(){
			var flag=this.fullScreenFlag;
			if(this.fullScreenFlag){
				 var element = document.getElementById("FullBody");  
			        requestFullScreen(element)
				    $('#fullScreen span').html('退出');
				    $('#fullScreen i').addClass('tool-small');
				    this.fullScreenFlag=false;
			}else{
				 // 判断各种浏览器，找到正确的方法
		        var exitMethod = document.exitFullscreen || // W3C
		            document.mozCancelFullScreen ||    // Chrome等
		            document.webkitExitFullscreen || // FireFox
		            document.webkitExitFullscreen; // IE11
		        if (exitMethod) {
		            exitMethod.call(document);
		        }
		        else if (typeof window.ActiveXObject !== "undefined") {// for Internet Explorer
		            var wscript = new ActiveXObject("WScript.Shell");
		            if (wscript !== null) {
		                wscript.SendKeys("{F11}");
		            }
		        }
				    $('#fullScreen span').html('全屏');
				    $('#fullScreen i').removeClass('tool-small');
				    this.fullScreenFlag=true;
			}
			
			  function requestFullScreen(element) {
			        // 判断各种浏览器，找到正确的方法
			        var requestMethod = element.requestFullScreen || // W3C
			            element.webkitRequestFullScreen ||    // Chrome等
			            element.mozRequestFullScreen || element.webkitallowfullscreen||element.mozallowfullscreen// FireFox
			            element.msRequestFullScreen; // IE11
			        if (requestMethod) {
			            requestMethod.call(element);
			        }
			        else if (typeof window.ActiveXObject !== "undefined") {// for Internet Explorer
			            var wscript = new ActiveXObject("WScript.Shell");
			            if (wscript !== null) {
			                wscript.SendKeys("{F11}");
			            }
			        }
			    }
		},
	    //添加图文标注
		addOverlayLabel:function(name, coordinate,overlayId) {
			var map = this.map;
			// 新增div元素
			var elementDiv = document.createElement('div');
			var overlay = document.getElementById('map'); // 获取id为label的元素
			overlay.appendChild(elementDiv); // 为ID为label的div层添加div子节点
			elementDiv.className = "marker";
			elementDiv.title = name;
			
			var elementTable = document.createElement('table');
			elementDiv.appendChild(elementTable);
			
			var elementTr = document.createElement('tr');
			elementTable.appendChild(elementTr);
			
			var elementTd1 = document.createElement('td');
			elementTr.appendChild(elementTd1);
			
			// 新建span标签
			var elementSpan = document.createElement("span");
			elementTd1.appendChild(elementSpan);
			// 新建img图标标签
			var elementImg = document.createElement("img");
			elementImg.src = "";
			elementSpan.appendChild(elementImg);

			var elementTd2 = document.createElement('td');
			elementTr.appendChild(elementTd2);
			// 新增a元素
			var elementA = document.createElement("a");
			elementA.className = "address";
			elementA.href = "#";
			setInnerText(elementA, elementDiv.title); // 设置文本
			elementTd2.appendChild(elementA); // 新建的div元素添加a子节点
			// 新建div元素
			var elementDiv1 = document.createElement('div');
			elementDiv1.className = "marker-line";
			elementDiv.appendChild(elementDiv1);
			// 新建div元素
			var elementDiv2 = document.createElement('div');
			elementDiv2.className = "marker-circle";
			elementDiv.appendChild(elementDiv2);
			var offset=0;
			if(elementDiv){
				offset=elementDiv.offsetWidth
			}
			var OverlayName=name;
			if(overlayId){
				OverlayName=overlayId;
			}
			this[OverlayName + 'Overlay'] = new ol.Overlay({
				id:OverlayName,
				position : coordinate,
				element : elementDiv,
				offset : [ -offset, -105 ],
				autoPan : true,
				autoPanAnimation : {
					duration : 250
				}
			});
			map.addOverlay(this[OverlayName + 'Overlay']);
			//动态设置元素文本内容（兼容）
			function setInnerText(element, text) {
				if (typeof element.textContent == "string") {
					element.textContent = text;
				} else {
					element.innerText = text;
				}
			}
		},
        
		//轨迹回放
		trackReplay:function(startBtnId,speed,routeCoords){
		    var map=this.map;
		    var  center=this.center;
		    var route = new ol.geom.LineString(routeCoords);
		    var routeLength = routeCoords.length;
		    var routeFeature = new ol.Feature({
		        type: 'route',
		        geometry: route
		    });
		    var geoMarker = new ol.Feature({
		        type: 'geoMarker',
		        geometry: new ol.geom.Point(routeCoords[0])
		    });
		    var startMarker = new ol.Feature({
		        type: 'startIcon',
		        geometry: new ol.geom.Point(routeCoords[0])
		    });
		    var endMarker = new ol.Feature({
		        type: 'endIcon',
		        geometry: new ol.geom.Point(routeCoords[routeLength - 1])
		    });

		    var styles = {
		        'route': new ol.style.Style({
		            stroke: new ol.style.Stroke({
		                width: 6, color: [237, 212, 0, 0.8]
		            })
		        }),
		        'startIcon': new ol.style.Style({
		            image: new ol.style.Icon({
		                anchor: [0.5, 1],
		                src: ctxStatic + '/modules/map/images/start.png'
		            })
		        }),
		        'endIcon': new ol.style.Style({
		            image: new ol.style.Icon({
		                anchor: [0.5, 1],
		                src:  ctxStatic + '/modules/map/images/end.png'
		            })
		        }),
		        'geoMarker': new ol.style.Style({
		            image: new ol.style.Circle({
		                radius: 10,
		                snapToPixel: false,
		                fill: new ol.style.Fill({color: 'black'}),
		                stroke: new ol.style.Stroke({
		                    color: 'white', width: 2
		                })
		            })
		        })
		    };

		    var animating = false;
		    var now;
		   // var speedInput = document.getElementById('speed');
		    var startButton = document.getElementById(startBtnId);
		    var vectorLayer = new ol.layer.Vector({
		        source: new ol.source.Vector({
		            features: [routeFeature, geoMarker, startMarker, endMarker]
		        }),
		        style: function(feature) {
		            // hide geoMarker if animation is active
		            if (animating && feature.get('type') === 'geoMarker') {
		                return null;
		            }
		            return styles[feature.get('type')];
		        }
		    });

		    map.addLayer(vectorLayer);
		    var moveFeature = function(event) {
		        var vectorContext = event.vectorContext;
		        var frameState = event.frameState;
		        if (animating) {
		            var elapsedTime = frameState.time - now;
		            // here the trick to increase speed is to jump some indexes
		            // on lineString coordinates
		            var index = Math.round(speed * elapsedTime / 1000);
		            if (index >= routeLength) {
		                stopAnimation(true);
		                return;
		            }
		            var currentPoint = new ol.geom.Point(routeCoords[index]);
		            var feature = new ol.Feature(currentPoint);
		            vectorContext.drawFeature(feature, styles.geoMarker);
		        }
		        // tell OpenLayers to continue the postcompose animation
		        map.render();
		    };

		    function startAnimation() {
		        if (animating) {
		            stopAnimation(false);
		        } else {
		            animating = true;
		            now = new Date().getTime();
		           // speed = speedInput.value;
		            startButton.textContent = '取消';
		            // hide geoMarker
		            geoMarker.setStyle(null);
		            // just in case you pan somewhere else
		            map.on('postcompose', moveFeature);
		            map.render();
		        }
		    }
		    function stopAnimation(ended) {
		        animating = false;
		        startButton.textContent = '开始';
		        // if animation cancelled set the marker at the beginning
		        var coord = ended ? routeCoords[routeLength - 1] : routeCoords[0];
		        /** @type {ol.geom.Point} */ (geoMarker.getGeometry())
		            .setCoordinates(coord);
		        // remove listener
		        map.un('postcompose', moveFeature);
		    }
		    //startButton.addEventListener('click', startAnimation, false);
		},
		//标注
		drawMark:function(drawType) {
			var map = this.map;
			var _this = this;
			// 绘制类型对象
			var typeSelect = drawType;
			// 删除图层
			this.removeLayer('vectorMark');
			// 删除图层
			this.removeLayer('drawMarkVector');
			map.removeInteraction(_this['drawDraw']);
			// 关闭编辑功能
			this.editGraphical(false);
			// 实例化一个矢量图层Vector作为绘制层
			_this['drawMarkVector'] = new ol.layer.Vector({
				source : new ol.source.Vector(),
				style : new ol.style.Style({
					fill : new ol.style.Fill({
						color : 'rgba(255, 255, 255, 0.7)'
					}),
					stroke : new ol.style.Stroke({
						color : '#0099ff',
						width : 2
					}),
					image : new ol.style.Circle({
						radius : 10,
						fill : new ol.style.Fill({
							color : '#0099ff'
						})
					})
				})
			});
			// 将绘制层添加到地图容器中
			map.addLayer(_this['drawMarkVector']); 
           //根据绘制类型进行交互绘制图形处理
			function addInteraction() {
				// 绘制类型
				var value = drawType; 
				// 实例化交互绘制类对象并添加到地图容器中
				_this['drawDraw'] = new ol.interaction.Draw({
					source : _this['drawMarkVector'].getSource(), // 绘制层数据源
					type :value// 几何图形类型
				
				});
				map.addInteraction(_this['drawDraw']);
				// 添加绘制结束事件监听，在绘制结束后保存信息到数据库
				_this['drawDraw'].on('drawend', drawEndCallBack, this);
			}
		   //用户更改绘制类型触发的事件
			// 添加交互绘制功能控件
			addInteraction(); 
			//绘制结束事件的回调函数，
			function drawEndCallBack(evt) {
				// 绘制图形类型
				var geoType = drawType;
				 // 当前绘制的要素
				_this.currentFeatureDraw = evt.feature;
				 // 获取要素的几何信息
				var geo = _this.currentFeatureDraw.getGeometry();
				// 获取几何坐标
				var coordinates = geo.getCoordinates(); 
				map.removeInteraction(_this['drawDraw']);
				// 将几何坐标拼接为字符串
				if (geoType == "Polygon") {
					var len = coordinates[0].length;
					var xSum = null, ySum = null, x = null, y = null;
					for (var i = 0; i < len; i++) {
						xSum += Number(coordinates[0][i][0]);
						ySum += Number(coordinates[0][i][1]);
					}
					x = xSum / len;
					y = ySum / len;
					_this.areaPointDraw = x + ',' + y;
					_this.geoStrDraw = coordinates[0].join(";");
				} else if (geoType == "LineString") {
					var len = coordinates.length;
					var xSum = null, ySum = null, x = null, y = null;
					for (var i = 0; i < len; i++) {
						xSum += Number(coordinates[i][0]);
						ySum += Number(coordinates[i][1]);
					}
					x = xSum / len;
					y = ySum / len;
					_this.areaPointDraw = x + ',' + y;
					_this.geoStrDraw = coordinates.join(";");
				} else {
					_this.geoStrDraw = coordinates.join(",");
					_this.areaPointDraw = _this.geoStrDraw;
				}
				$('.tag-panl-span').removeClass('active');
				if($('#areaPoint').length>0){
					$('#areaPoint').val(_this.geoStrDraw)
				}
				console.log(_this.geoStrDraw)
			}
		},
		//地图标注信息
		markInfo : function(id, type, selectedNodes) {
			this.markInfoId = id;
			this.markInfoType = type;
			this.selectedNodes = selectedNodes;
		},
        //标注加载默认数据
		addGraphical:function(type) {
			var map = this.map;
			var _this = this;
			// 删除图层vectorMark
			this.removeLayer('vectorMark');// 删除图层
			this.removeLayer('drawMarkVector');// 删除图层
			// 关闭编辑功能
			this.editGraphical(false);
			// 绘制的几何图形要素
			var Feature;
			var coordinate = [];
			// 点
			if (type == "Point") {
				coordinate = _this.selectedNodes[0].areaPoint.split(';')[0].split(',');
				Feature = new ol.Feature(new ol.geom.Point(coordinate));
			} else if (type == "LineString") {
				var coordinateArr = _this.selectedNodes[0].areaMap.split(';');
				if (coordinateArr.length != 0) {
					for (var i = 0; i < coordinateArr.length; i++) {
						coordinate.push(coordinateArr[i].split(','))
					}
				}
				Feature = new ol.Feature(new ol.geom.LineString( coordinate ));
			} else if (type == "Polygon") {
				var coordinateArr = _this.selectedNodes[0].areaMap.split(';');
				if (coordinateArr.length != 0) {
					for (var i = 0; i < coordinateArr.length; i++) {
						coordinate.push(coordinateArr[i].split(','))
					}
				}
				Feature = new ol.Feature(new ol.geom.Polygon([ coordinate ]));
			}

			// 实例化一个矢量图层Vector作为绘制层
			var source = new ol.source.Vector({
				features : [ Feature ]
			});

			this['vectorMark'] = new ol.layer.Vector({
				source : source,
				style : new ol.style.Style({
					fill : new ol.style.Fill({
						color : 'rgba(255, 255, 255, 0.2)'
					}),
					stroke : new ol.style.Stroke({
						color : 'blue',
						width : 2
					}),
					image : new ol.style.Circle({
						radius : 10,
						fill : new ol.style.Fill({
							color : 'blue'
						})
					})
				})
			});
			// 将绘制层添加到地图容器中
			map.addLayer(this['vectorMark']); 
			var areaPointCenter=_this.selectedNodes[0].areaPoint.split(';')[0].split(',');
			if(areaPointCenter.length==2){
				this.goTo(areaPointCenter);
			}
		},
        //图形编辑
		editGraphical : function(flag) {
			var map = this.map;
			var _this = this;
			if (flag) {
				// 初始化一个交互选择控件,并添加到地图容器中
				_this.selectGraphical = new ol.interaction.Select();
				map.addInteraction(_this.selectGraphical);
				// 初始化一个交互编辑控件，并添加到地图容器中
				_this.modifyGraphical = new ol.interaction.Modify({
					features : _this.selectGraphical.getFeatures()
				// 选中的要素
				});
				map.addInteraction(_this.modifyGraphical);

				// 选中的要素
				var selectedFeaturesGraphical = _this.selectGraphical.getFeatures();
				// 添加选中要素变更事件
				_this.selectGraphical.on('change:active', function() {
					selectedFeaturesGraphical.forEach(selectedFeaturesGraphical.remove,
							selectedFeaturesGraphical);
				});
				// 图层修改结束事件，获取坐标
				_this.modifyGraphical.on('modifyend', function() {
					var geo = selectedFeaturesGraphical.getArray()[0].getGeometry(); // 获取要素的几何信息
					var coordinates = geo.getCoordinates(); // 获取几何坐标
					var geoType=geo.getType();
					// 将几何坐标拼接为字符串
					if (geoType == "Polygon") {
						var len = coordinates[0].length;
						var xSum = null, ySum = null, x = null, y = null;
						for (var i = 0; i < len; i++) {
							xSum += Number(coordinates[0][i][0]);
							ySum += Number(coordinates[0][i][1]);
						}
						x = xSum / len;
						y = ySum / len;
						_this.areaPointDraw = x + ',' + y;
						_this.geoStrDraw = coordinates[0].join(";");
					} else if (geoType == "LineString") {
						var len = coordinates.length;
						var xSum = null, ySum = null, x = null, y = null;
						for (var i = 0; i < len; i++) {
							xSum += Number(coordinates[i][0]);
							ySum += Number(coordinates[i][1]);
						}
						x = xSum / len;
						y = ySum / len;
						_this.areaPointDraw = x + ',' + y;
						_this.geoStrDraw = coordinates.join(";");
					} else {
						_this.geoStrDraw = coordinates.join(",");
						_this.areaPointDraw = _this.geoStrDraw;
					}
					if($('#areaPoint').length>0){
						$('#areaPoint').val(_this.geoStrDraw)
					}
				});
				
			}
			if (_this.selectGraphical) {
				// 激活--注销选择要素控件
				_this.selectGraphical.setActive(flag);
				// 激活--注销修改要素控件
				_this.modifyGraphical.setActive(flag);
			}
		},
       
		// 画线
		drakLine:function(PlanFlagId){
			var map=this.map;
			var _this=this;
			var flag=null;
			if(this['planFlagLine']){
			  flag=_this['planFlagLine'].getVisible();
			}
			this.removeLayer('planFlagLine')
			 var Feature = new ol.Feature(new ol.geom.LineString( PlanFlagId ));
				var source = new ol.source.Vector({
					features : [ Feature ]
				});
				_this['planFlagLine']= new ol.layer.Vector({
					source : source,
					style : new ol.style.Style({
						fill : new ol.style.Fill({
							color : 'rgba(255, 255, 255, 0.2)'
						}),
						stroke : new ol.style.Stroke({
							color : 'blue',
							width : 2
						}),
						image : new ol.style.Circle({
							radius : 10,
							fill : new ol.style.Fill({
								color : 'blue'
							})
						})
					})
				});
				map.addLayer(_this['planFlagLine']); // 将绘制层添加到地图容器中
				_this.layersIsShow('planFlagLine', flag);//设置图层显示隐藏
		},
		//添加电子围栏
		addElectronicFence:function(id,type,ElectronicFenceData) {
			var map = this.map;
			var _this = this;
			// 绘制的几何图形要素
			var Feature;
			var coordinate = [];
			// 点
			if (type == "Point") {
				coordinate = ElectronicFenceData.split(';')[0].split(',');
				Feature = new ol.Feature(new ol.geom.Point(coordinate));
			} else if (type == "LineString") {
				var coordinateArr = ElectronicFenceData.split(';');
				if (coordinateArr.length != 0) {
					for (var i = 0; i < coordinateArr.length; i++) {
						coordinate.push(coordinateArr[i].split(','))
					}
				}
				Feature = new ol.Feature(new ol.geom.LineString( coordinate ));
			} else if (type == "Polygon") {
				var coordinateArr = ElectronicFenceData.split(';');
				if (coordinateArr.length != 0) {
					for (var i = 0; i < coordinateArr.length; i++) {
						coordinate.push(coordinateArr[i].split(','))
					}
				}
				Feature = new ol.Feature(new ol.geom.Polygon([ coordinate ]));
			}

			// 实例化一个矢量图层Vector作为绘制层
			var source = new ol.source.Vector({
				features : [ Feature ]
			});

			this['ElectronicFence'] = new ol.layer.Vector({
				source : source,
				style : new ol.style.Style({
					fill : new ol.style.Fill({
						color : 'rgba(255, 255, 255, 0)'
					}),
					stroke : new ol.style.Stroke({
						color : 'red',
						width : 2
					}),
					   text: new ol.style.Text({
	                        text: '电子围栏区域',
                            font:'normal 15px 微软雅黑',
	                        exceedLength:'true',
	                        fill: new ol.style.Fill({
	                            color: 'red'
	                        }),
	                        stroke : new ol.style.Stroke({
	    						color : 'red',
	    						width : 1
	    					}),
	                    })
				})
			});
			// 将绘制层添加到地图容器中
			map.addLayer(this['ElectronicFence']); 
//			var areaPointCenter=_this.selectedNodes[0].areaPoint.split(';')[0].split(',');
//			if(areaPointCenter.length==2){
//				this.goTo(areaPointCenter);
//			}
		},
		//记载数据--涉及点聚合-style中feature为整个数组
		addJSON1:function(params){
			var map = this.map;
			var _this = this;
			// 加载数据
			var vectorArr = params;
			var len = vectorArr.length;
			if (len > 0) {
				for (var i = 0; i < len; i++) {
					this.center = vectorArr[i].data.centpoint;
					var vectorArrType = vectorArr[i].type;
					// 添加到矢量数据源
					var Data=vectorArr[i].data.features;
					var DataLen=Data.length;
					var vectorSource=null;
					var clusterSource=null;
					var layerVectortype=vectorSource;
					if(DataLen>0){
						//字符串转化为number数据  ['137','47']=>[137,47]
						for(var j=0;j<DataLen;j++){
							if(Data[j].geometry.type=="Point"){
								vectorArr[i].data.features[j].geometry.coordinates[0]=Number(vectorArr[i].data.features[j].geometry.coordinates[0])
								vectorArr[i].data.features[j].geometry.coordinates[1]=Number(vectorArr[i].data.features[j].geometry.coordinates[1])
							}else if(Data[j].geometry.type=="Polygon"){
								var PolygonLen=vectorArr[i].data.features[j].geometry.coordinates.length;
								if(PolygonLen>0){
									for(var k=0;k<PolygonLen;k++){
										var coordinates=vectorArr[i].data.features[j].geometry.coordinates[k];
										var coordinatesLen=coordinates.length;
										if(coordinatesLen>0){
											for(var m=0;m<coordinatesLen;m++){
												vectorArr[i].data.features[j].geometry.coordinates[k][m][0]=Number(	vectorArr[i].data.features[j].geometry.coordinates[k][m][0])
												vectorArr[i].data.features[j].geometry.coordinates[k][m][1]=Number(	vectorArr[i].data.features[j].geometry.coordinates[k][m][1])

											}
										}
									}
								}
							}else if(Data[j].geometry.type=="LineString"){
								var LineStringLen=vectorArr[i].data.features[j].geometry.coordinates.length;
								if(LineStringLen>0){
									for(var k=0;k<LineStringLen;k++){
										var coordinates=vectorArr[i].data.features[j].geometry.coordinates[k];
										var coordinatesLen=coordinates.length;
										if(coordinatesLen>0){
											vectorArr[i].data.features[j].geometry.coordinates[k][0]=Number(	vectorArr[i].data.features[j].geometry.coordinates[k][0])
											vectorArr[i].data.features[j].geometry.coordinates[k][1]=Number(	vectorArr[i].data.features[j].geometry.coordinates[k][1])
										}
									}
								}
							}
						}
					}
					//数据
					vectorSource=this.vectorGeoJSON(vectorArr[i].data)
					//点聚合
					clusterSource=this.cluster(vectorSource);
					 if(DataLen>0){
							for(var j=0;j<DataLen;j++){
								if(Data[j].geometry.type=="Point"){
									layerVectortype=clusterSource;
								}else if(Data[j].geometry.type=="Polygon"){
									layerVectortype=vectorSource;
								}
							}
						}
						
					var styleCache = {};
					var cont1=0;
					this[vectorArrType] = new ol.layer.Vector({
								visible : vectorArr[i].isShow,
								source :layerVectortype,
								// 设置样式
								style : function(feature) {
									//图标地址
									var iconSrc = feature.get('icon');
									var colorArr = _this.colorArr;
									var index = Math.floor((Math.random() * colorArr.length));
								    var fillColor = colorArr[index].rgba;
									var color = colorArr[index].color;
									if(vectorArrType=="resultCheck"){
										iconSrc=feature.get('info').color;//巡逻结果颜色
									}
									//中心
									var coordinate = feature.get('coordinateCentre');
									//返回样式
									if(_this.featureStyles(iconSrc,feature)[vectorArrType]){
										return  _this.featureStyles(iconSrc,feature)[vectorArrType];
										}else {

											//点聚合  点feature为数组
											var GeometryType=feature.getGeometry().getType();
											if(GeometryType=="Point"){
												var  selectedFeatures=feature.get('features');
												var idIndex="";
										        selectedFeatures.map(function(feature) {
                                                     idIndex+=feature.getId()
												});
												var size = selectedFeatures.length;
									            var style = styleCache[idIndex];
									            if (!style) {
								                var color = size > 25 ? "192,0,0" : size > 8 ? "255,128,0" : "0,128,0";
								                var radius = Math.max(8, Math.min(size * 0.75, 20));
								                var dash = 2 * Math.PI * radius / 6;
								                dash = [0, dash, dash, dash, dash, dash, dash];
									              if(size==1){
									            	  var Src=feature.get('features')[0].get('icon');
									                    style = styleCache[idIndex] = [
									                    	new ol.style.Style({
																	image : new ol.style.Icon({
																				src : ctxStatic+ '/modules/map/images/'+ Src+ '',
																				scale : map.getView().getZoom() / 15
																			}),
																	text: new ol.style.Text({
												                                textAlign: 'center', // 位置
												                                textBaseline: 'top', // 基准线
												                                offsetY:'10',
												                                exceedLength:'true',
												                                font: 'normal 10px 微软雅黑',  // 文字样式
												                                text: feature.get('features')[0].get('name'),  // 文本内容
												                                fill: new ol.style.Fill({ color: '#aa3300' }), // 文本填充样式（即文字颜色）
												                                stroke: new ol.style.Stroke({ color: '#ffcc33', width: 2 })
												                            })

									                    	})
										                ];
									                	    
									                }
									                else{
									                    style = styleCache[idIndex] = [new ol.style.Style({
										                    image: new ol.style.Circle({
										                        radius: radius,
										                        stroke: new ol.style.Stroke({
										                            color: "rgba(" + color + ",0.5)",
										                            width: 15,
										                            lineDash: dash,
										                            lineCap: "butt"
										                        }),
										                        fill: new ol.style.Fill({
										                            color: "rgba(" + color + ",1)"
										                        })
										                    }),
										                    text: new ol.style.Text({
										                        text: size.toString(),
										                        fill: new ol.style.Fill({
										                            color: '#fff'
										                        })
										                    })
										                })
										                ];
									                }
									            }
									            return style;
											}else{
											 var size = feature.getId();
											 var style = styleCache[size];
											 if (!style) {
												 style = styleCache[size]=[
													 new ol.style.Style({
															fill : new ol.style.Fill({
																		color : fillColor ? fillColor: 'rgba(255, 255, 255, 0.6)'
															}),
															stroke : new ol.style.Stroke({
																		color : color ? color: 'blue',
																		width : 3
															}),
															text: new ol.style.Text({
										                                textAlign: 'center', // 位置
										                                textBaseline: 'middle', // 基准线
										                                exceedLength:'true',
										                                font: 'normal 12px 微软雅黑',  // 文字样式
										                                text: feature.get('name'),  // 文本内容
										                                fill: new ol.style.Fill({ color: '#fff' }), // 文本填充样式（即文字颜色）
															})

													 }),
												]
											 }
												return  style
											}
										}

								}
							});
					map.addLayer(this[vectorArr[i].type]);
				}
			}
			// 图层显示隐藏
			// this[type].setVisible(flag);
			if( this.selectPointerFlag){
				_this.selectPointer();
			}
		},
		//记载数据--不涉及点聚合-style中feature为数组中某一个值
        addJSON2:function(params){
        	var map = this.map;
        	var colorArr = this.colorArr;
        	var _this = this;
        	// 加载数据
        	var vectorArr = params;
        	var len = vectorArr.length;
        	if (len > 0) {
        		for (var i = 0; i < len; i++) {
        			this.center = vectorArr[i].data.centpoint;
        			var vectorArrType = vectorArr[i].type;
        			// 添加到矢量数据源
        			var Data=vectorArr[i].data.features;
        			var DataLen=Data.length;
        			var vectorSource=null;
        			var clusterSource=null;
        			var layerVectortype=vectorSource;
        
        			 
        			 vectorSource=this.vectorGeoJSON(vectorArr[i].data)
        			 var styleCache = {};
        			 var cont1=0;
        			 this[vectorArrType] = new ol.layer.Vector(
        					
        					{
        						visible : vectorArr[i].isShow,
        						source :vectorSource,
        						renderOrder : function(feature) {
        						},
        						// 设置样式
        						style : function(feature) {
        							var index = Math.floor((Math.random() * colorArr.length));
        							var fillColor = colorArr[index].rgba;
        							var color = colorArr[index].color;
        							var iconSrc = feature.get('icon');
        							//console.log(iconSrc)
        							var coordinate = feature.get('coordinateCentre');
        							//返回样式
									if(vectorArrType=="resultCheck"){
										iconSrc=feature.get('info').color;//巡逻结果颜色
									}
									if(_this.featureStyles(iconSrc,feature)[vectorArrType]){
										return  _this.featureStyles(iconSrc,feature)[vectorArrType];
									}else{
										 var size = feature.getId();
										 var style = styleCache[size];
										 if (!style) {
											 style = styleCache[size]=[ _this.featureStyles(iconSrc,feature)['default']]
										 }
									  return  style
									}
        						}
							});
					map.addLayer(this[vectorArr[i].type]);
        		}
        	}

        	// 图层显示隐藏
        	// this[type].setVisible(flag);
        	if( this.selectPointerFlag){
        		_this.selectPointer();
        	}
			
		},
} 




/**
 * 概括加载地图，地图联动，使用同一个view
 */
var viewSituation
(function viewSituationFun(){
	var zoom=14.75,centerCoordinate= [ 117.663920, 39.035650 ];
	windowsHeight = $(window).width();
	if (windowsHeight>=1680&&windowsHeight<1920) {
		zoom=14.7;
		centerCoordinate= [ 117.662920, 39.035650 ]
	} else if(windowsHeight>=1600&&windowsHeight<1680){
		zoom=14.4;
		centerCoordinate= [ 117.662920, 39.035650 ]
	}else if(windowsHeight>=1440&&windowsHeight<1660){
		zoom=14.4;
		centerCoordinate= [ 117.662920, 39.035650 ]
	}else if(windowsHeight<1440) {
		zoom=14.1;
		centerCoordinate= [ 117.662920, 39.035650 ]
	}

	viewSituation = new ol.View({
			center : centerCoordinate,
			zoom : zoom,
			maxZoom : 18,
			minZoom : 9.8,
			projection : 'EPSG:4326'
		});
})()

ArjMap.Map.prototype.drawMapSituation = function() {
	var baseUrl = this.baseUrl;
	var urlArr = this.urlArr;

	var layers=[];
    var len=baseUrl.length;
    if(len>0){
        for(var i=0;i<len;i++){
        	if(typeof (baseUrl[i].type)!="undefined"){
        	if(baseUrl[i].type=='xianchang'){
        	     this[baseUrl[i].id+'Tile']=new ol.layer.Tile({
                     title : "地图",
                     opacity:1,
                     name : baseUrl[i].name,
                     visible : baseUrl[i].isShow,
                     source : new ol.source.XYZ({
                         tileGrid: new ol.tilegrid.TileGrid({
                             tileSize:baseUrl[i].tileSize,
                             // 原点  
                             origin: baseUrl[i].origin,
                             resolutions: baseUrl[i].resolutions

                         }),
                         url : baseUrl[i].url,
                         projection : 'EPSG:4326'
                         // 天地图
                     })
                 });
        	}else if(baseUrl[i].type=='tiandi'){
        		  this[baseUrl[i].id+'Tile']=new ol.layer.Tile({
                      title : "地图",
                      name : baseUrl[i].name,
                      visible : baseUrl[i].isShow,
                      source : new ol.source.XYZ({
                          url : baseUrl[i].url,
                          // 天地图
                      })
                  });
        		
        	}
           	 layers.push(this[baseUrl[i].id+'Tile'])
        	}
		}

	}
	this.map = new ol.Map({
		layers : layers,
		view : viewSituation,
		target : this.id,
		controls : ol.control.defaults({
			zoom : this.zoomShowOrHide,
		// attribution: this.showOLpage
		})
	});
	if (urlArr && urlArr.length > 0) {
		var len = urlArr.length;
		for (var i = 0; i < len; i++) {
			this.map.addLayer(new ol.layer.Tile({
				name : urlArr[i].name,
				visible : urlArr[i].isShow,
				source : new ol.source.TileArcGISRest({
					url : urlArr[i].url,
				})
			}))
		}
	}
	
	this.map.addInteraction(new ol.interaction.Select({
		condition : ol.events.condition.pointerMove, // 唯一的不同之处，设置鼠标移到feature上就选取
		style : new ol.style.Style({
			image : new ol.style.Circle({
				radius : 10,
				fill : new ol.style.Fill({
					color : '#0099ff'
				})
			}),
			fill : new ol.style.Fill({
				color : 'rgba(255, 255, 255, 0.7)'
			}),
			stroke : new ol.style.Stroke({
				color : '#0099ff',
				width : 2
			}),
		})
	}));
}











//app.js

var map,Map, plotDraw, plotEdit, drawOverlay, drawStyle;

var center = [ 117.648920, 39.034450 ];

function init(){

	// 地图默认数据设置
	var defaultPrams = {
		id : 'map',
		centerCoordinate : [ 117.648920, 39.034450 ],
		zoom : 15,
		maxZoom : 20,
		minZoom : 2,
		baseUrl :baseUrlD,
		zoomShowOrHide : false,// 缩小放大
		overviewMap : true
	// 鹰眼图
	}
    　	Map = new ArjMap.Map(defaultPrams);
	// 加载地图
	Map.init();

    map=Map.map;
	
	
	/*工具栏*/
    $('.tag-panl-span').click(function(){
    	$(this).addClass('active').parent().siblings().children('.tag-panl-span').removeClass('active');
    })
    $('.tag-panl-close').click(function(){
    	$('#TagPanl').hide();
    })
    
    /*轨迹点位*/
    var pushArr = [[117.63434886932373, 39.02674198150635],
    	[117.64155864715576, 39.02519702911377],
    	[117.6436185836792,  39.031291007995605],
    	[117.6436185836792,  39.031291007995605],
    	[117.65469757843018, 39.028871886291504]];
    var objId ;
    objId=$("#objId").val();//id
    var createDate;
    createDate = $("#createDate").val();//时间
    
    //获取轨迹点位和电子围栏
    $.getJSON("/arjccm/a/sys/map/deviceMobileAlarm?deviceId="+objId+"&beginCurDate="+createDate+"&endCurDate="+createDate,
			function(data) {
				// 轨迹点位
    			var Data = data[0];
    			if(Data.length!=0){
    				var str=Data.substring(0,Data.length-1)
        			var routeCoords=str.split(';')
        		    var len=routeCoords.length;
        		    var pushArr=[]
        		    for(var i=0;i<len;i++){
        		    	var value=[];
        		    	 value[0]=Number(routeCoords[i].split(',')[0]);
        		    	 value[1]=Number(routeCoords[i].split(',')[1]);
        		    	 pushArr.push(value);
        		    }
    			}
    		    console.log(pushArr)
    		    Map.trackReplay('start-animation',5,pushArr);
    		    //电子围栏
    		    var ElectronicFence=data[1]
    		    Map.addElectronicFence('111','Polygon',ElectronicFence)
    			//定位到中心
    		    var areaPoint=data[2];
    		    if(areaPoint.length!=0){
	    		    var aps=[];
	    		    aps[0]=Number(areaPoint.split(',')[0]);
	    		    aps[1]=Number(areaPoint.split(',')[1]);
	    		    Map.goTo(aps);
    		    }
    			
	});
 
}

//标注绘制
function drawMark(type){
	Map.drawMark(type)
}

//工具栏
function HasChildren(){
	$('#TagPanl').show()
}
