/*
 * Copyright 2005-2016 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao;

import java.util.List;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Goods;
import net.shopxx.entity.Member;
import net.shopxx.entity.Review;
import net.shopxx.entity.Store;

/**
 * Dao - 评论
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface ReviewDao extends BaseDao<Review, Long> {

	/**
	 * 查找评论
	 * 
	 * @param member
	 *            会员
	 * @param goods
	 *            货品
	 * @param type
	 *            类型
	 * @param isShow
	 *            是否显示
	 * @param count
	 *            数量
	 * @param filters
	 *            筛选
	 * @param orders
	 *            排序
	 * @return 评论
	 */
	List<Review> findList(Member member, Goods goods, Review.Type type, Boolean isShow, Integer count, List<Filter> filters, List<Order> orders);

	/**
	 * 查找评论分页
	 * 
	 * @param member
	 *            会员
	 * @param goods
	 *            货品
	 * @param store
	 *            店铺
	 * @param type
	 *            类型
	 * @param isShow
	 *            是否显示
	 * @param pageable
	 *            分页信息
	 * @return 评论分页
	 */
	Page<Review> findPage(Member member, Goods goods, Store store, Review.Type type, Boolean isShow, Pageable pageable);

	/**
	 * 查找评论数量
	 * 
	 * @param member
	 *            会员
	 * @param goods
	 *            货品
	 * @param type
	 *            类型
	 * @param isShow
	 *            是否显示
	 * @return 评论数量
	 */
	Long count(Member member, Goods goods, Review.Type type, Boolean isShow);

	/**
	 * 计算货品总评分
	 * 
	 * @param goods
	 *            货品
	 * @return 货品总评分，仅计算显示评论
	 */
	long calculateTotalScore(Goods goods);

	/**
	 * 计算货品评分次数
	 * 
	 * @param goods
	 *            货品
	 * @return 货品评分次数，仅计算显示评论
	 */
	long calculateScoreCount(Goods goods);

}