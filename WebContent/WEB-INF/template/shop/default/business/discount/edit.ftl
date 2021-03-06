[#escape x as x?html]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("shop.business.discount.edit")}</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/shop/${theme}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/${theme}/css/business.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/jquery.autocomplete.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/webuploader.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/ueditor/ueditor.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/input.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/datePicker/WdatePicker.js"></script>
<style type="text/css">
.memberRank label, .coupon label {
	min-width: 120px;
	_width: 120px;
	display: block;
	float: left;
	padding-right: 4px;
	_white-space: nowrap;
}
</style>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $browserButton = $("a.browserButton");
	var $giftSelect = $("#giftSelect");
	var $giftTable = $("#giftTable");
	var $giftTitle = $("#giftTable tr:first");
	var $introduction = $("#introduction");
	
	[@flash_message /]
	
	$browserButton.uploader();
	
	$introduction.editor();
	
	// 赠品选择
	$giftSelect.autocomplete("gift_select.jhtml", {
		dataType: "json",
		extraParams: {
			excludeIds: function() {
				return $giftTable.find("input:hidden").map(function() {
					return $(this).val();
				}).get();
			}
		},
		cacheLength: 0,
		max: 20,
		width: 218,
		scrollHeight: 300,
		parse: function(data) {
			return $.map(data, function(item) {
				return {
					data: item,
					value: item.name
				}
			});
		},
		formatItem: function(item) {
			return '<span title="' + escapeHtml(item.name) + '">' + escapeHtml(abbreviate(item.name, 50, "...")) + '<\/span>' + (item.specifications.length > 0 ? ' <span class="silver">[' + escapeHtml(item.specifications.join(", ")) + ']<\/span>' : '');
		}
	}).result(function(event, item) {
		var $giftTr = (
			[@compress single_line = true]
				'<tr>
					<td>
						<input type="hidden" name="giftIds" value="' + item.id + '" \/>
						' + item.sn + '
					<\/td>
					<td>
						<span title="' + escapeHtml(item.name) + '">' + escapeHtml(abbreviate(item.name, 50, "...")) + '<\/span>' + (item.specifications.length > 0 ? ' <span class="silver">[' + escapeHtml(item.specifications.join(", ")) + ']<\/span>' : '') + '
					<\/td>
					<td>
						<a href="' + escapeHtml(item.url) + '" target="_blank">[${message("shop.common.view")}]<\/a>
						<a href="javascript:;" class="remove">[${message("shop.common.remove")}]<\/a>
					<\/td>
				<\/tr>'
			[/@compress]
		);
		$giftTitle.show();
		$giftTable.append($giftTr);
	});
	
	// 删除赠品
	$giftTable.on("click", "a.remove", function() {
		var $this = $(this);
		$.dialog({
			type: "warn",
			content: "${message("shop.dialog.deleteConfirm")}",
			onOk: function() {
				$this.closest("tr").remove();
				if ($giftTable.find("tr").size() <= 1) {
					$giftTitle.hide();
				}
				$giftSelect.val("");
			}
		});
	});
	
	$.validator.addMethod("compare", 
		function(value, element, param) {
			var parameterValue = $(param).val();
			if ($.trim(parameterValue) == "" || $.trim(value) == "") {
				return true;
			}
			try {
				return parseFloat(parameterValue) <= parseFloat(value);
			} catch(e) {
				return false;
			}
		},
		"${message("shop.business.discount.compare")}"
	);
	
	// 表单验证
	$inputForm.validate({
		rules: {
			name: "required",
			title: "required",
			image: {
				pattern: /^(http:\/\/|https:\/\/|\/).*$/i
			},
			minimumPrice: {
				min: 0,
				decimal: {
					integer: 12,
					fraction: ${setting.priceScale}
				}
			},
			maximumPrice: {
				min: 0,
				decimal: {
					integer: 12,
					fraction: ${setting.priceScale}
				},
				compare: "#minimumPrice"
			},
			minimumQuantity: "digits",
			maximumQuantity: {
				digits: true,
				compare: "#minimumQuantity"
			},
			discount: {
				min: 0,
				decimal: {
					integer: 3,
					fraction: 3
				}
			},
			adjustmentPoint: {
				digits: true,
				min:0
			}
		}
	});

});
</script>
</head>
<body>
	[#assign current = "discountList" /]
	[#include "/shop/${theme}/include/header.ftl" /]
	<div class="container business">
		<div class="row">
		[#include "/shop/${theme}/business/include/menu.ftl" /]
			<div class="span10">
				<div class="list clearfix">
					<form id="inputForm" action="update.jhtml" method="post">
						<input type="hidden" name="id" value="${promotion.id}" />
						<ul id="tab" class="tab">
							<li>
								<input type="button" value="${message("shop.business.discount.base")}" />
							</li>
							<li>
								<input type="button" value="${message("Promotion.introduction")}" />
							</li>
						</ul>
						<table class="input tabContent">
							<tr>
								<th>
									<span class="requiredField">*</span>${message("Promotion.name")}:
								</th>
								<td>
									<input type="text" name="name" class="text" value="${promotion.name}" maxlength="200" />
								</td>
							</tr>
							<tr>
								<th>
									<span class="requiredField">*</span>${message("Promotion.title")}:
								</th>
								<td>
									<input type="text" name="title" class="text" value="${promotion.title}" maxlength="200" />
								</td>
							</tr>
							<tr>
								<th>
									${message("Promotion.image")}:
								</th>
								<td>
									<span class="fieldSet">
										<input type="text" name="image" class="text" value="${promotion.image}" maxlength="200" />
										<a href="javascript:;" class="button browserButton">${message("shop.upload.filePicker")}</a>
										[#if promotion.image?has_content]
											<a href="${promotion.image}" target="_blank">${message("shop.common.view")}</a>
										[/#if]
									</span>
								</td>
							</tr>
							<tr>
								<th>
									${message("Promotion.beginDate")}:
								</th>
								<td>
									<input type="text" id="beginDate" name="beginDate" class="text Wdate" value="[#if promotion.beginDate??]${promotion.beginDate?string("yyyy-MM-dd HH:mm:ss")}[/#if]" onfocus="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss', maxDate: '#F{$dp.$D(\'endDate\')}'});" />
								</td>
							</tr>
							<tr>
								<th>
									${message("Promotion.endDate")}:
								</th>
								<td>
									<input type="text" id="endDate" name="endDate" class="text Wdate" value="[#if promotion.endDate??]${promotion.endDate?string("yyyy-MM-dd HH:mm:ss")}[/#if]" onfocus="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss', minDate: '#F{$dp.$D(\'beginDate\')}'});" />
								</td>
							</tr>
							<tr>
								<th>
									${message("Promotion.minimumPrice")}:
								</th>
								<td>
									<input type="text" id="minimumPrice" name="minimumPrice" class="text" value="${promotion.minimumPrice}" maxlength="16" />
								</td>
							</tr>
							<tr>
								<th>
									${message("Promotion.maximumPrice")}:
								</th>
								<td>
									<input type="text" name="maximumPrice" class="text" value="${promotion.maximumPrice}" maxlength="16" />
								</td>
							</tr>
							<tr>
								<th>
									${message("Promotion.minimumQuantity")}:
								</th>
								<td>
									<input type="text" id="minimumQuantity" name="minimumQuantity" class="text" value="${promotion.minimumQuantity}" maxlength="9" />
								</td>
							</tr>
							<tr>
								<th>
									${message("Promotion.maximumQuantity")}:
								</th>
								<td>
									<input type="text" name="maximumQuantity" class="text" value="${promotion.maximumQuantity}" maxlength="9" />
								</td>
							</tr>
							<tr>
								<th>
									${message("Promotion.discount")}:
								</th>
								<td>
									<input type="text" name="discount" class="text" title="${message("shop.business.fullReduction.discountNote")}" value="${promotion.discount}" maxlength="9" />
								</td>
							</tr>
							<tr>
								<th>
									${message("Promotion.adjustmentPoint")}:
								</th>
								<td>
									<input type="text" name="adjustmentPoint" class="text" value="${promotion.adjustmentPoint}" maxlength="9" />
								</td>
							</tr>
							<tr class="memberRank">
								<th>
									${message("Promotion.memberRanks")}
								</th>
								<td>
									[#list memberRanks as memberRank]
										<label>
											<input type="checkbox" name="memberRankIds" value="${memberRank.id}"[#if promotion.memberRanks?seq_contains(memberRank)] checked="checked"[/#if] />${memberRank.name}
										</label>
									[/#list]
								</td>
							</tr>
							<tr class="coupon">
								<th>
									${message("Promotion.coupons")}
								</th>
								<td>
									[#list coupons as coupon]
										<label>
											<input type="checkbox" name="couponIds" value="${coupon.id}"[#if promotion.coupons?seq_contains(coupon)] checked="checked"[/#if] />${coupon.name}
										</label>
									[/#list]
								</td>
							</tr>
							<tr>
								<th>
									${message("shop.common.setting")}:
								</th>
								<td>
									<label>
										<input type="checkbox" name="isFreeShipping" value="true"[#if promotion.isFreeShipping] checked="checked"[/#if] />${message("Promotion.isFreeShipping")}
										<input type="hidden" name="_isFreeShipping" value="false" />
									</label>
									<label>
										<input type="checkbox" name="isCouponAllowed" value="true"[#if promotion.isCouponAllowed] checked="checked"[/#if] />${message("Promotion.isCouponAllowed")}
										<input type="hidden" name="_isCouponAllowed" value="false" />
									</label>
									<label>
										<input type="checkbox" name="isEnabled" value="true"[#if promotion.isEnabled] checked="checked"[/#if] />${message("Promotion.isEnabled")}
										<input type="hidden" name="_isEnabled" value="false" />
									</label>
								</td>
							</tr>
							<tr>
								<th>
									${message("Promotion.gifts")}:
								</th>
								<td>
									<input type="text" id="giftSelect" name="giftSelect" class="text" maxlength="200" title="${message("shop.common.giftSelectTitle")}" />
								</td>
							</tr>
							<tr>
								<th>
									&nbsp;
								</th>
								<td>
									<table id="giftTable" class="item">
										<tr[#if !promotion.gifts?has_content] class="hidden"[/#if]>
											<th>
												${message("Product.sn")}
											</th>
											<th>
												${message("Product.name")}
											</th>
											<th>
												${message("shop.common.action")}
											</th>
										</tr>
										[#list promotion.gifts as gift]
											<tr>
												<td>
													<input type="hidden" name="giftIds" value="${gift.id}" />
													${gift.sn}
												</td>
												<td>
													<span title="${gift.name}">${abbreviate(gift.name, 50, "...")}</span>
													[#if gift.specifications?has_content]
														<span class="silver">[${gift.specifications?join(", ")}]</span>
													[/#if]
												</td>
												<td>
													<a href="${gift.url}" target="_blank">[${message("shop.common.view")}]</a>
													<a href="javascript:;" class="remove">[${message("shop.common.remove")}]</a>
												</td>
											</tr>
										[/#list]
									</table>
								</td>
							</tr>
						</table>
						<table class="input tabContent">
							<tr>
								<td>
									<textarea id="introduction" name="introduction" class="editor" style="width: 100%;">${promotion.introduction}</textarea>
								</td>
							</tr>
						</table>
						<table class="input">
							<tr>
								<th>
									&nbsp;
								</th>
								<td>
									<input type="submit" class="button" value="${message("shop.common.submit")}" />
									<input type="button" class="button" value="${message("shop.common.back")}" onclick="history.back(); return false;" />
								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>
		</div>
	</div>
	[#include "/shop/${theme}/include/footer.ftl" /]
</body>
</html>
[/#escape]