#pragma once

#include <vector>
#include <opencv2\core.hpp>

class Map_Node;
class Agent;
class Task;

class World
{
public:
	World(const int &param_file, const bool &display_plot, const bool &score_run, const std::vector<cv::String> &task_selection_method);
	// doing everything
	void iterate_all();
	double get_team_probability_at_time_except(const double & time, const int & task, const int & except_agent);
	~World();

	// accessing private vars
	std::vector<Agent*> get_agents() { return this->agents; };
	std::vector<Map_Node*> get_nodes() { return this->nodes; };
	int get_n_nodes() { return this->n_nodes; };
	int get_n_agents() { return this->n_agents; };
	double get_c_time() { return this->c_time; };
	double get_dt() { return this->dt; };
	double get_end_time() { return this->end_time; };
	cv::String get_task_selection_method() { return this->task_selection_method[this->test_iter]; };
	std::vector<bool> get_task_status_list() { return this->task_status_list; };
	std::string get_mcts_search_type() { return this->mcts_search_type; };

	// utility functions
	bool a_star(const int & start, const int & goal, const bool &pay_obstacle_cost, std::vector<int>& path, double & length);
	double dist2d(const double & x1, const double & x2, const double & y1, const double & y2);
	bool dist_between_nodes(const int & n1, const int & n2, double & d);
	void display_world(const int & ms);
	bool get_edge_cost(const int &n1, const int &n2, const bool &pay_obstacle_cost, double &cost);
	double get_height() { return double(this->map_height); };
	double get_width() { return double(this->map_width); };
	bool get_index(const std::vector<int>& vals, const int & key, int & index);
	bool get_mindex(const std::vector<double> &vals, int &mindex, double &minval);
	bool get_travel_time(const int & s, const int & g, const double & step_dist, const bool &pay_obstacle_cost, double & time);
	bool get_task_completion_time(const int &agent_index, const int &task_index, double &time);
	bool get_travel_cost(const int &s, const int &g, const bool &pay_obstacle_cost, double &cost);
	double rand_double_in_range(const double & min, const double & max);
	bool valid_node(const int & n);
	bool valid_agent(const int a);
	bool are_nbrs(const int &t1, const int &t2);

private:


	int test_iter, n_iterations;
	double c_time, dt, end_time;
	std::string mcts_search_type;
	bool show_display, score_run;
	double last_plot_time;
	int n_nodes, n_agents;
	int n_agent_types, n_task_types;
	double p_task_initially_active, p_impossible_task, p_activate_task;
	double min_task_time, max_task_time;
	double min_travel_vel, max_travel_vel;
	double map_width, map_height;
	double p_pay_obstacle_cost; // probability that a generated agent will have to pay obstacle tolls

	int k_map_connections; // minimum number of connections in graph
	double k_connection_radius; // how close should I be to connect
	double p_connect; // probability of connecting if in radius
	double p_obstacle_on_edge; // probability an obstacle is on the edge
	double p_blocked_edge; // probability that an edge is blocked
	
	cv::Mat PRM_Mat;
	std::vector<Map_Node*> nodes;
	std::vector<Agent*> agents;
	std::vector<cv::String> task_selection_method;
	std::vector<bool> task_status_list;
	
	// initialize everything
	int param_file_index;
	char* param_file;
	int rand_seed;
	void write_params();
	void load_params();
	void initialize_nodes_and_tasks();
	void initialize_PRM();
	void initialize_agents();

	// get cost of each time step
	void score_and_record_all();
	double get_time_step_open_reward();
	double get_time_step_collected_reward();
	double cumulative_open_reward;

	// do stuff
	void iterate_agents();
	void generate_tasks();
	void run_simulation();
	void clean_up_from_sim();
};


/*
cv::Mat obstacle_mat;
void create_random_obstacles();
void find_obstacle_costs();
*/

